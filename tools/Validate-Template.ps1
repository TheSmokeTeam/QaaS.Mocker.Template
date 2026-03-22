param(
    [string]$Configuration = "Release",
    [string]$PackageVersion,
    [string]$PackageSource = "https://api.nuget.org/v3/index.json"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$packageProject = Join-Path $repoRoot "QaaS.Mocker.Template.Package.csproj"
$templateShortName = "qaas-mocker"
$templatePackageId = "QaaS.Mocker.Template"
$runtimePackageId = "QaaS.Mocker"
$generatedName = "Smoke.QaaS.Mocker"
$artifactRoot = Join-Path $repoRoot "artifacts"
$packageOutput = Join-Path $artifactRoot "package"
$smokeRoot = Join-Path $artifactRoot "smoke"
$runRoot = Join-Path $smokeRoot ([Guid]::NewGuid().ToString("N"))
$generatedRoot = Join-Path $runRoot "generated"

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

function Get-ProjectVersion {
    param([string]$ProjectPath)

    [xml]$projectXml = Get-Content $ProjectPath
    $version = $projectXml.Project.PropertyGroup.Version
    if ([string]::IsNullOrWhiteSpace($version)) {
        throw "Could not determine package version from '$ProjectPath'."
    }

    return $version
}

function Get-LatestPackageVersion {
    param(
        [string]$PackageId,
        [string]$Source
    )

    $output = dotnet package search $PackageId --source $Source --take 1
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to query latest version for '$PackageId' from '$Source'."
    }

    foreach ($line in $output) {
        if ($line -match "^\|\s*$([Regex]::Escape($PackageId))\s*\|\s*([^|]+?)\s*\|") {
            return $Matches[1].Trim()
        }
    }

    throw "Could not parse the latest version for '$PackageId' from 'dotnet package search'."
}

function Get-ResolvedPackageVersion {
    param(
        [string]$AssetsFilePath,
        [string]$PackageId
    )

    $assets = Get-Content $AssetsFilePath -Raw | ConvertFrom-Json
    $libraryName = $assets.libraries.PSObject.Properties.Name |
        Where-Object { $_ -like "$PackageId/*" } |
        Select-Object -First 1

    if ([string]::IsNullOrWhiteSpace($libraryName)) {
        throw "Could not find '$PackageId' in '$AssetsFilePath'."
    }

    return ($libraryName -split "/", 2)[1]
}

function Assert-PackageShape {
    param([string]$PackagePath)

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::OpenRead($PackagePath)

    try {
        $entryNames = $zip.Entries | Select-Object -ExpandProperty FullName
        $invalidEntries = @($entryNames | Where-Object { $_ -match "(^|/)(bin|obj)/" })
        $localFeedEntries = @($entryNames | Where-Object { $_ -like "content/.nuget/local-packages/*" })

        Assert-True ($invalidEntries.Count -eq 0) (
            "Template package should not contain build output, but found: {0}" -f ($invalidEntries -join ", ")
        )
        Assert-True ($localFeedEntries.Count -eq 0) (
            "Template package should not vendor local mocker packages anymore, but found: {0}" -f ($localFeedEntries -join ", ")
        )
    }
    finally {
        $zip.Dispose()
    }
}

$projectVersion = Get-ProjectVersion -ProjectPath $packageProject
if ([string]::IsNullOrWhiteSpace($PackageVersion)) {
    $PackageVersion = "$projectVersion-ci"
}

New-Item -ItemType Directory -Force -Path $packageOutput | Out-Null
New-Item -ItemType Directory -Force -Path $runRoot | Out-Null

$env:DOTNET_CLI_HOME = Join-Path $runRoot "cli-home"
$env:NUGET_PACKAGES = Join-Path $runRoot "nuget-packages"
$env:DOTNET_NOLOGO = "true"
$env:DOTNET_CLI_TELEMETRY_OPTOUT = "true"
$env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1"

Get-ChildItem $packageOutput -Filter "$templatePackageId*.nupkg" -ErrorAction SilentlyContinue | Remove-Item -Force

dotnet pack $packageProject `
    --configuration $Configuration `
    -p:PackageVersion=$PackageVersion `
    --output $packageOutput
if ($LASTEXITCODE -ne 0) {
    throw "dotnet pack failed."
}

$package = Get-ChildItem $packageOutput -Filter "$templatePackageId*.nupkg" |
    Where-Object { $_.Name -notlike "*.snupkg" } |
    Select-Object -First 1

Assert-True ($null -ne $package) "Template package was not created."
Assert-PackageShape -PackagePath $package.FullName

dotnet new install $package.FullName
if ($LASTEXITCODE -ne 0) {
    throw "dotnet new install failed."
}

dotnet new $templateShortName -n $generatedName -o $generatedRoot
if ($LASTEXITCODE -ne 0) {
    throw "dotnet new $templateShortName failed."
}

git -C $generatedRoot init | Out-Null

$solutionPath = Join-Path $generatedRoot "$generatedName.sln"
$generatedProjectRoot = Join-Path $generatedRoot $generatedName
$projectFile = Join-Path $generatedProjectRoot "$generatedName.csproj"
$nuGetConfig = Join-Path $generatedRoot "NuGet.config"
$readmePath = Join-Path $generatedRoot "README.md"
$yamlPath = Join-Path $generatedProjectRoot "mocker.qaas.yaml"
$dockerfilePath = Join-Path $generatedRoot "Dockerfile"
$generatedWorkflowPath = Join-Path $generatedRoot ".github\workflows\ci.yml"
$assetsFile = Join-Path $generatedProjectRoot "obj\project.assets.json"

Assert-True (Test-Path $solutionPath) "Generated solution file is missing."
Assert-True (Test-Path $projectFile) "Generated project file is missing."
Assert-True (Test-Path $nuGetConfig) "Generated NuGet.config is missing."
Assert-True (Test-Path $readmePath) "Generated README is missing."
Assert-True (Test-Path $yamlPath) "Generated mocker.qaas.yaml is missing."
Assert-True (Test-Path $dockerfilePath) "Generated Dockerfile is missing."
Assert-True (Test-Path $generatedWorkflowPath) "Generated GitHub Actions workflow is missing."

$projectText = Get-Content $projectFile -Raw
$nuGetConfigText = Get-Content $nuGetConfig -Raw
$readmeText = Get-Content $readmePath -Raw
$yamlText = Get-Content $yamlPath -Raw

Assert-True ($projectText -match '<PackageReference Include="QaaS\.Mocker" Version="\*" />') (
    "Generated project should use a floating QaaS.Mocker package reference."
)
Assert-True ($projectText -notmatch 'QaaS\.Common\.Processors') (
    "Generated project should not reference QaaS.Common.Processors directly."
)
Assert-True ($nuGetConfigText -match '<clear />') (
    "Generated NuGet.config should clear inherited sources."
)
Assert-True ($nuGetConfigText -match 'https://api\.nuget\.org/v3/index\.json') (
    "Generated NuGet.config should default to nuget.org."
)
Assert-True ($nuGetConfigText -notmatch 'local-packages') (
    "Generated NuGet.config should no longer reference template-local package caches."
)
Assert-True ($yamlText -match '(?m)^Servers:\s*$') (
    "Generated YAML should use the current 'Servers' array shape."
)
Assert-True ($yamlText -notmatch '(?m)^Server:\s*$') (
    "Generated YAML should no longer use the deprecated singular 'Server' shape."
)
Assert-True ($yamlText -match 'QaaS\.Framework\.SDK\.Hooks\.BaseHooks\.StatusCodeTransactionProcessor') (
    "Generated YAML should use the fully qualified status code processor."
)
Assert-True ($readmeText -match 'Servers') (
    "Generated README should describe the current server configuration shape."
)

dotnet restore $solutionPath --configfile $nuGetConfig
if ($LASTEXITCODE -ne 0) {
    throw "dotnet restore failed."
}

dotnet build $solutionPath -c $Configuration --no-restore
if ($LASTEXITCODE -ne 0) {
    throw "dotnet build failed."
}

$lintOutput = & dotnet run -c $Configuration --project $projectFile -- -m Lint mocker.qaas.yaml 2>&1 | Out-String
if ($LASTEXITCODE -ne 0) {
    throw "Mocker lint execution failed.`n$lintOutput"
}

Assert-True ($lintOutput -match 'Lint mode completed successfully') (
    "Mocker lint output did not report success.`n$lintOutput"
)
Assert-True ($lintOutput -notmatch 'Property Type in path Server') (
    "Mocker lint output still reports the deprecated Server.Type warning.`n$lintOutput"
)

$latestRuntimeVersion = Get-LatestPackageVersion -PackageId $runtimePackageId -Source $PackageSource
$resolvedRuntimeVersion = Get-ResolvedPackageVersion -AssetsFilePath $assetsFile -PackageId $runtimePackageId

Assert-True ($resolvedRuntimeVersion -eq $latestRuntimeVersion) (
    "Generated project restored QaaS.Mocker $resolvedRuntimeVersion, but the latest published version on '$PackageSource' is $latestRuntimeVersion."
)

Write-Host "Validated $templatePackageId using $runtimePackageId $resolvedRuntimeVersion."

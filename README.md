# QaaS.Mocker.Template

Installable `dotnet new` template pack for creating Rider-friendly QaaS mocker projects.

## What This Repo Publishes

- Template package ID: `QaaS.Mocker.Template`
- Current release: `1.1.0`
- Template short name: `qaas-mocker`
- Template display name in IDEs: `QaaS Mocker Project`

After the template pack is installed, Rider and the `dotnet new` CLI can create a new QaaS mocker project with:

- `Program.cs` following the example-project startup pattern
- `Dockerfile`
- `NuGet.config`
- a minimal HTTP `/health` endpoint
- no custom processor code in the generated project
- generated-project GitHub Actions CI
- the latest mocker package pinned in this release: `QaaS.Mocker` `2.0.0-alpha.12`
- `QaaS.Common.Processors` pinned to `1.0.1-alpha.9`

## Download Options

The easiest public install path is the GitHub release asset:

- `QaaS.Mocker.Template.1.1.0.nupkg`

Download it from the `1.1.0` release page for this repository, then install it with `dotnet new install`.

This package can also be installed from GitHub Packages if you have a token that can read packages from `TheSmokeTeam`.

## Important Packaging Note

As of March 15, 2026, `QaaS.Mocker` `2.0.0-alpha.12` on `nuget.org` still depends on `QaaS.Mocker.Controller` and `QaaS.Mocker.Servers`, but those packages are not published there.

To keep the generated template working from a clean machine, this template pack vendors the matching package chain inside the generated project under `.nuget/local-packages` and wires it through `NuGet.config`.

## Install From a Downloaded Release

1. Download `QaaS.Mocker.Template.1.1.0.nupkg` from the `1.1.0` release.
2. Install it:

```bash
dotnet new install .\QaaS.Mocker.Template.1.1.0.nupkg
```

3. Verify it is available:

```bash
dotnet new list qaas-mocker
```

## Install Directly From a Local Clone

From the repository root:

```bash
dotnet new install .
```

## Install From GitHub Packages

GitHub Packages for NuGet requires authentication. After configuring your GitHub package source, install a specific version with:

```bash
dotnet new install QaaS.Mocker.Template::1.1.0 --add-source https://nuget.pkg.github.com/TheSmokeTeam/index.json
```

## Create a New Mocker Project

CLI:

```bash
dotnet new qaas-mocker -n MyCompany.QaaS.Mocker
```

Rider:

1. Install the template pack with `dotnet new install`.
2. Open Rider.
3. Go to `New Solution` or `New Project`.
4. Open the `.NET` templates list.
5. Search for `QaaS Mocker Project` or `qaas`.
6. Create the project.

If Rider was already open before installation, refresh the new project dialog or restart Rider.

The generated project includes a `launchSettings.json` profile named `QaaS Mocker` with `mocker.qaas.yaml`, plus a generated `.github/workflows/ci.yml` that restores, builds, lints the YAML, and builds the Docker image when the project is pushed to GitHub.

## Uninstall

```bash
dotnet new uninstall QaaS.Mocker.Template
```

To list installed template packs:

```bash
dotnet new uninstall
```

## Update

If you installed from release assets, the safe update path is:

1. Uninstall the old pack:

```bash
dotnet new uninstall QaaS.Mocker.Template
```

2. Download the newer release asset.
3. Install the newer `.nupkg`:

```bash
dotnet new install .\QaaS.Mocker.Template.<new-version>.nupkg
```

## Install a Specific Version

Pick the exact release you want from GitHub Releases, download its `.nupkg`, then install that file:

```bash
dotnet new install .\QaaS.Mocker.Template.1.1.0.nupkg
```

If you are installing from a package feed, the supported CLI syntax for a fixed version is:

```bash
dotnet new install QaaS.Mocker.Template::1.1.0
```

## Build the Template Pack Locally

```bash
dotnet pack .\QaaS.Mocker.Template.Package.csproj -c Release -o .\artifacts
```

## Generated Project

The files copied into new projects live under the `template/` folder in this repository.

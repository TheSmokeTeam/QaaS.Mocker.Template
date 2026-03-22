# QaaS.Mocker.Template

Installable `dotnet new` template pack for creating Rider-friendly QaaS mocker projects.

## What This Repo Publishes

- Template package ID: `QaaS.Mocker.Template`
- Template short name: `qaas-mocker`
- Template display name in IDEs: `QaaS Mocker Project`

After the template pack is installed, Rider and the `dotnet new` CLI can create a new QaaS mocker project with:

- `Program.cs` following the example-project startup pattern
- `Dockerfile`
- `NuGet.config`
- a minimal HTTP `/health` endpoint under the current `Servers` YAML shape
- no custom processor code in the generated project
- generated-project GitHub Actions CI
- `QaaS.Mocker` referenced with `Version="*"` so restore resolves the latest stable package on the configured feed
- the health stub configured against `QaaS.Framework.SDK.Hooks.BaseHooks.StatusCodeTransactionProcessor`

## Download Options

The easiest public install path is the latest GitHub release asset:

- `QaaS.Mocker.Template.<version>.nupkg`

Download it from this repository's Releases page, then install it with `dotnet new install`.

## Install From a Downloaded Release

1. Download `QaaS.Mocker.Template.<version>.nupkg` from Releases.
2. Install it:

```bash
dotnet new install .\QaaS.Mocker.Template.<version>.nupkg
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

To run the full local validation flow that packs, installs, generates a repo, restores, builds, and lints the default config:

```powershell
.\tools\Validate-Template.ps1
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

If you restore from a private feed or local Artifactory, update the generated `NuGet.config` before the first restore.

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
dotnet new install .\QaaS.Mocker.Template.<version>.nupkg
```

If you are installing from a package feed, the supported CLI syntax for a fixed version is:

```bash
dotnet new install QaaS.Mocker.Template::<version>
```

## Build the Template Pack Locally

```bash
dotnet pack .\QaaS.Mocker.Template.Package.csproj -c Release -o .\artifacts
```

## Generated Project

The files copied into new projects live under the `template/` folder in this repository.

# QaaS.Mocker.Template

Installable `dotnet new` template for new QaaS mocker repos.

## Install

```bash
dotnet new install QaaS.Mocker.Template
# or
dotnet new install .\QaaS.Mocker.Template.<version>.nupkg
# or, from this repo root
dotnet new install .
```

## Create

```bash
dotnet new qaas-mocker -n MyCompany.QaaS.Mocker
```

The generated repo includes:
- `NuGet.config` pointing at `nuget.org`
- `QaaS.Mocker` with `Version="*"` so restore pulls the latest stable version from the configured feed
- a minimal `/health` mock under `Servers`
- `Dockerfile` and generated GitHub Actions CI

If you restore from a private feed or local Artifactory, update the generated `NuGet.config` before the first restore.

## Validate Local Changes

```powershell
.\tools\Validate-Template.ps1
```

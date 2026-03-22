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
- empty `DataSources`, `Stubs`, and `Servers` lists
- `Dockerfile` and generated GitHub Actions CI

If you restore from a private feed or local Artifactory, update the generated `NuGet.config` before the first restore.

## Pack Locally

```bash
dotnet pack .\QaaS.Mocker.Template.Package.csproj -p:PackageVersion=1.2.2 -o .\artifacts\package
dotnet new install .\artifacts\package\QaaS.Mocker.Template.1.2.2.nupkg
dotnet new qaas-mocker -n MyCompany.QaaS.Mocker
```

Add at least one server to `mocker.qaas.yaml` before linting or running the generated mocker project.

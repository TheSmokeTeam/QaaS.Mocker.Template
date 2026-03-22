# QaaS Mocker Project

This project was created from the `QaaS.Mocker.Template` dotnet template pack.

## Included Defaults

- `Program.cs` runs `QaaS.Mocker.Bootstrap.New(args).Run()`
- `NuGet.config` defaults restores to `nuget.org`
- `mocker.qaas.yaml` starts with empty `DataSources`, `Stubs`, and `Servers` lists
- `Dockerfile`, `NuGet.config`, and `.github/workflows/ci.yml` are included

## First Steps

```bash
dotnet restore --configfile NuGet.config
```

Add at least one server to `QaaS.Mocker.Template/mocker.qaas.yaml`, then lint or run it:

```bash
dotnet run --project QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -- -m Lint QaaS.Mocker.Template/mocker.qaas.yaml
dotnet run --project QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -- QaaS.Mocker.Template/mocker.qaas.yaml
```

If you restore from a private feed or local Artifactory, update `NuGet.config` before the first restore.

# QaaS Mocker Project

This project was created from the `QaaS.Mocker.Template` dotnet template pack.

## Included Defaults

- `Program.cs` follows the example-project startup pattern and normalizes `--no-env`
- `NuGet.config` defaults restores to `nuget.org`
- `mocker.qaas.yaml` defines a single HTTP `/health` endpoint under `Servers`
- `mocker.qaas.yaml` uses `QaaS.Framework.SDK.Hooks.BaseHooks.StatusCodeTransactionProcessor`, so there is no custom processor code to maintain
- `Dockerfile`, `NuGet.config`, and `.github/workflows/ci.yml` are included

## First Run

```bash
dotnet restore --configfile NuGet.config
dotnet run --project QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -- -m Lint mocker.qaas.yaml
dotnet run --project QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -- mocker.qaas.yaml
```

Then call:

```bash
curl http://localhost:8080/health
```

## Validate

```bash
dotnet run --project QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -- -m Lint mocker.qaas.yaml
docker build -t qaas-mocker-project .
```

If you restore from a private feed or local Artifactory, update `NuGet.config` before the first restore.

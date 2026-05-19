# QaaS Mocker Project

This project was created from the `QaaS.Mocker.Template` dotnet template pack.

## Included Defaults

- `Program.cs` runs `QaaS.Mocker.Bootstrap.New(args).Run()`
- `NuGet.config` restores from `QAAS_NUGET_SOURCE_URL`
- `mocker.qaas.yaml` includes a minimal local `/health` mock on `http://127.0.0.1:8080`
- `Processors/HealthProcessor.cs` returns the default plain-text health payload
- `Dockerfile`, `NuGet.config`, and `.github/workflows/ci.yml` are included

## First Run

```bash
export QAAS_NUGET_SOURCE_URL=https://api.nuget.org/v3/index.json
dotnet restore --configfile NuGet.config --source "$QAAS_NUGET_SOURCE_URL"
dotnet run --project QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -- run mocker.qaas.yaml
curl http://127.0.0.1:8080/health
```

Use this as a starting point for your own stubs and endpoints. For example, you can render the effective configuration before expanding it:

```bash
dotnet run --project QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -- template mocker.qaas.yaml
```

If you restore from a private feed or local Artifactory, set `QAAS_NUGET_SOURCE_URL` before restoring or building the Docker image.

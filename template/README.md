# QaaS Mocker Project

This project was created from the `QaaS.Mocker.Template` dotnet template pack.

## Included Files

- `QaaS.Mocker.Template/Program.cs`
- `QaaS.Mocker.Template/Processors/HealthProcessor.cs`
- `QaaS.Mocker.Template/mocker.qaas.yaml`
- `Dockerfile`
- `NuGet.config`
- `.nuget/local-packages`

## Quick Start

```bash
dotnet restore QaaS.Mocker.Template.sln --configfile NuGet.config
dotnet run --project QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -- -m Lint mocker.qaas.yaml
dotnet run --project QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -- mocker.qaas.yaml
```

Then call:

```bash
curl http://localhost:8080/health
```

## Docker

```bash
docker build -t qaas-mocker-project .
docker run --rm -p 8080:8080 qaas-mocker-project
```

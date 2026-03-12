# QaaS.Mocker.Template

Minimal Rider-friendly QaaS mocker project template with Docker support.

## Includes

- `QaaS.Mocker` `2.0.0-alpha.7`
- `Program.cs` wired to `QaaS.Mocker.Bootstrap.New(args).Run()`
- a minimal HTTP `/health` mocker configuration
- a matching `HealthProcessor`
- `Dockerfile`
- a local NuGet feed under `.nuget/local-packages`

## Why the local feed exists

As of March 12, 2026, `QaaS.Mocker` `2.0.0-alpha.7` on `nuget.org` depends on `QaaS.Mocker.Controller` and `QaaS.Mocker.Servers`, but those packages are not published there. This template vendors the latest package chain locally so restore, build, Rider, and Docker all work from a clean clone.

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
docker build -t qaas-mocker-template .
docker run --rm -p 8080:8080 qaas-mocker-template
```

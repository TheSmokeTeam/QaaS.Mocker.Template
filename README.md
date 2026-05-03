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
- `NuGet.config` pointing at `nuget.org` by default, with template parameters to override the feed name and URL at creation time
- `QaaS.Mocker` with `Version="2.*"` so restore pulls the latest stable `2.x.x` version from the configured feed
- a minimal `/health` mock under `Servers`
- a local `HealthProcessor` implementation for the default response
- `Dockerfile` and generated GitHub Actions CI, with template parameters to override the SDK and runtime images at creation time

Create a private-feed and private-registry project directly from the template with:

```bash
dotnet new qaas-mocker -n MyCompany.QaaS.Mocker --nugetFeedName qaas-private --nugetFeedUrl https://artifactory.example/api/nuget/qaas/index.json --dockerSdkImage registry.example.local/dotnet/sdk:10.0 --dockerRuntimeImage registry.example.local/dotnet/runtime:10.0
```

If you publish a separate internal template package, keep the source tree shared and change only the `defaultValue` entries for `nugetFeedName`, `nugetFeedUrl`, `dockerSdkImage`, and `dockerRuntimeImage` in `template/.template.config/template.json` before packing the internal variant.

## Pack Locally

```bash
dotnet pack .\QaaS.Mocker.Template.Package.csproj -p:PackageVersion=1.3.6 -o .\artifacts\package
dotnet new install .\artifacts\package\QaaS.Mocker.Template.1.3.6.nupkg
dotnet new qaas-mocker -n MyCompany.QaaS.Mocker
```

Run the generated project with `dotnet run -- run mocker.qaas.yaml`, then request `http://127.0.0.1:8080/health` to verify the default mock.

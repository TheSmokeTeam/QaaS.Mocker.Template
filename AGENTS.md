# AGENTS.md — QaaS.Mocker.Template

Guidance for AI agents working in this repository.

## What this repo is

The `dotnet new` template package for QaaS mock-server projects.

- Install: `dotnet new install QaaS.Mocker.Template` → instantiate: `dotnet new qaas-mocker -n Org.Project`
- Package: `QaaS.Mocker.Template` (PackageType=Template); identity `SmokeTeam.QaaS.Mocker.Project.1.2.2`.
- Generated project: net10.0 Exe, one-line `Program.cs` (`QaaS.Mocker.Bootstrap.New(args).Run();`), working `mocker.qaas.yaml` (HTTP :8080 localhost `/health` → `HealthStub`), `Processors/HealthProcessor.cs` (`BaseTransactionProcessor<NoConfiguration>` returning 200 "healthy"), multi-stage `Dockerfile`, generated `.github/workflows/ci.yml` (build + conditional YAML lint + docker build), reference to `QaaS.Mocker` `Version="*"`.
- Run a generated project: `dotnet run -- run mocker.qaas.yaml`; verify `curl http://127.0.0.1:8080/health` → `healthy`.

## Layout

- `QaaS.Mocker.Template.Package.csproj` — packs `template/**` → `content/`.
  Pack: `dotnet pack .\QaaS.Mocker.Template.Package.csproj -c Release -p:PackageVersion=<v> -o .\artifacts\package`
- `template/.template.config/template.json` — sourceName replacement, `skipRestore` symbol.
- `template/QaaS.Mocker.Template/` — project + `Processors/`; `template/Dockerfile`; `template/.github/workflows/ci.yml` (this CI ships INTO generated projects).

## Template validation loop

```powershell
dotnet pack .\QaaS.Mocker.Template.Package.csproj -c Release -p:PackageVersion=9.9.9 -o .\artifacts\package
dotnet new install .\artifacts\package\QaaS.Mocker.Template.9.9.9.nupkg
dotnet new qaas-mocker -o sandbox -n Test.Project
dotnet build sandbox\Test.Project.sln
dotnet new uninstall QaaS.Mocker.Template   # ALWAYS
Remove-Item sandbox -Recurse -Force
```

## Gotchas

- **Namespace not renamed on instantiation**: `HealthProcessor` keeps namespace `QaaS.Mocker.Template.Processors` after `-n MyCo.X` — sourceName covers project/sln names only. Stub `Processor:` references in YAML must match actual processor names. Document or fix via template.json replacements if touching this.
- **Dockerfile names are not templated** — references the original project name; ENTRYPOINT passes the YAML directly (`["dotnet","QaaS.Mocker.Template.dll","mocker.qaas.yaml"]`, no `-- run` prefix).
- **IsLocalhost: true binds 127.0.0.1** — unreachable from outside Docker; integration tests in containers need `IsLocalhost: false` or port-mapping awareness.
- Generated CI lints YAML only when `Servers` is non-empty (regex `^Servers:\s*\[\]\s*$` skip); lint verb: `dotnet run -c Release --no-build -- -m Lint mocker.qaas.yaml`.
- Template caching: `dotnet new uninstall` before reinstall.
- Generated CI is a static copy — template CI changes don't propagate to existing projects.

## Process

QaaS harness pipeline for non-trivial changes (plan → contract → implement → adversarial evaluation, rubric ≥7/10 per dimension). Acceptance evidence: the full pack→install→instantiate→build→(run /health)→uninstall loop. Conventional commits.

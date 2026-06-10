# Copilot instructions — QaaS.Mocker.Template

Read `AGENTS.md` at the repo root first.

Essentials:
- `dotnet new` template package: content under `template/`, packed by `QaaS.Mocker.Template.Package.csproj`.
- Short name `qaas-mocker`; generated project runs `dotnet run -- run mocker.qaas.yaml` (HTTP :8080 `/health` sample with `HealthProcessor`).
- Acceptance evidence for changes: pack → install → instantiate → build → `dotnet new uninstall` (mandatory — cache poisons reinstalls).
- sourceName replacement does NOT rewrite the `Processors` namespace or YAML stub references — keep them consistent manually.
- `IsLocalhost: true` binds 127.0.0.1 only; Dockerfile names aren't templated.

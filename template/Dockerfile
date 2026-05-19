ARG DOTNET_SDK_IMAGE=mcr.microsoft.com/dotnet/sdk:10.0
ARG DOTNET_RUNTIME_IMAGE=mcr.microsoft.com/dotnet/runtime:10.0

FROM ${DOTNET_SDK_IMAGE} AS build
WORKDIR /src
COPY . .
ARG QAAS_NUGET_SOURCE_URL
ENV QAAS_NUGET_SOURCE_URL=${QAAS_NUGET_SOURCE_URL}
RUN dotnet restore QaaS.Mocker.Template.sln --configfile NuGet.config --source "${QAAS_NUGET_SOURCE_URL}"
RUN dotnet publish QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -c Release -o /app/publish --no-restore

FROM ${DOTNET_RUNTIME_IMAGE}
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "QaaS.Mocker.Template.dll", "mocker.qaas.yaml"]

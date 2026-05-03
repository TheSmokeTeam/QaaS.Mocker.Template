FROM QAAS_DOCKER_SDK_IMAGE AS build
WORKDIR /src
COPY . .
RUN dotnet restore QaaS.Mocker.Template.sln --configfile NuGet.config
RUN dotnet publish QaaS.Mocker.Template/QaaS.Mocker.Template.csproj -c Release -o /app/publish --no-restore

FROM QAAS_DOCKER_RUNTIME_IMAGE
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "QaaS.Mocker.Template.dll", "mocker.qaas.yaml"]

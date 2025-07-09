# Imagen base de .NET (elige la versión según tu proyecto)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ProcessApi.csproj", "./"]
RUN dotnet restore "./ProcessApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet publish "ProcessApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "ProcessApi.dll"]

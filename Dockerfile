#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM microsoft/dotnet:2.1-aspnetcore-runtime-nanoserver-1803 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk-nanoserver-1803 AS build
WORKDIR /src
COPY ["superCoreApp/superCoreApp.csproj", "superCoreApp/"]
RUN dotnet restore "superCoreApp/superCoreApp.csproj"
COPY . .
WORKDIR "/src/superCoreApp"
RUN dotnet build "superCoreApp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "superCoreApp.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "superCoreApp.dll"]
# Используем официальный .NET SDK для сборки приложения
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем файлы проекта и восстанавливаем зависимости
COPY *.sln .
COPY ExampleTestProject/*.csproj ./ExampleTestProject/
COPY ExampleWebService/*.csproj ./ExampleWebService/
RUN dotnet restore

# Копируем весь исходный код и собираем приложение
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Создаем финальный образ для запуска
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Открываем порт для приложения
EXPOSE 8181

# Команда запуска приложения
ENTRYPOINT ["dotnet", "ExampleWebService.dll"]

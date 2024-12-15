# Externals.Vcpkg

Репозиторий сборки сторонних библиотек при помощи
[vcpkg](https://github.com/microsoft/vcpkg).

- Ссылки на нужные библиотеки устанавливать в vcpkg.json (если файл vcpkg.json
есть папкой выше, то для сборки будет использоваться он, иначе - файл в этой
папке).
- Для сборок под Android необходимо через переменную окружения
ANDROID_NDK_HOME установить путь к папке нужной версии Android NDK.

> Ссылка на определенный tag vcpkg автоматически приводит к сборке версий
> библиотек, которые этот tag содержит.

> Настройка флагов сборки по умолчанию - в папке vcpkg\scripts\toolchains;
> например, замена в windows.cmake /Z7 на /Zc:inline уменьшит размер
> собранных библиотек для windows.

### Сборка библиотек как SDK

- Клонировать репозиторий для нужного тега.
- Запустить скрипт Build.SDK.cmd.

> Запускать скрипт следует от имени пользователя Windows, в имени которого нет
> скобок или переопределить для такого пользователя переменные окружения TEMP и
> TMP.

Результатом будет архив ExternalsSDK_v0.0.0.0.7z, содержащий собранные
библиотеки (x64 для Windows и ARM64 для Android), соответствующие выбранному
тегу версий.

### Автоматическая сборка библиотек при сборке проектов решения

- Подключить репозиторий к нужному проекту как субмодуль.
- Добавить в решение проект, которому в событии перед сборкой добавить запуск 
скрипта Build.cmd и добавить всем остальным проектам зависимость от этого проекта.

> Скрипт Build.cmd собирает библиотеки один раз, при наличии собранных
> библиотек просто завершается; если необходимо выполнить пересборку, удалить
> папку Externals.Vcpkg\Externals и сделать clean up в папке Externals.Vcpkg\Vcpkg.

### Использование

[Все варианты](https://github.com/Unicornum/Example.Externals.Vcpkg)
подключения и использования готовых сборок.

### Проблемы

- [15.12.2024] Использование **android-ndk-r27c** вызывает ошибку при сборке
freeglut (нужен для freeimage на Android).
- [20.12.2024] Из-за долгого времени сборки она может завершиться с ошибкой
из-за нестабильной связи с Интернетом; в этом случае просто запустить скрипт
заново- vcpkg дособерет недостающие библиотеки.

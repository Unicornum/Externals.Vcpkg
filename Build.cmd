@echo off

set ANDROID_NDK_HOME=E:\Android\android-ndk-r16b

rem Проверить наличие собранных библиотек
IF exist .\Vcpkg\installed\x64-windows-static goto EndOfFile

rem Копирование в папку .\Vcpkg\ports папки настройки сборки фейковой библиотеки 
rem externals-dependencies, единственная задача которой - подтянуть зависимости.
robocopy .\externals-dependencies .\vcpkg\ports\externals-dependencies

rem Собрать vcpkg
cd vcpkg
call bootstrap-vcpkg.bat

rem Запуск сборки externals.dependencies (x64/ARM64 Debug/Release)
vcpkg install externals-dependencies:x64-windows-static
vcpkg install externals-dependencies:arm64-android

rem Библиотеки собираются в \packages\...
rem Результат копируется в \installed\...

cd..
:EndOfFile

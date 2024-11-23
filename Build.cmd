@echo off

set ANDROID_NDK_HOME=E:\Android\android-ndk-r16b

rem Проверить наличие собранных библиотек
IF exist .\Vcpkg\installed\windows goto EndOfFile

rem Собрать vcpkg
cd vcpkg
call bootstrap-vcpkg.bat

cd..

rem Запуск сборки vcpkg.json (x64/ARM64 Debug/Release)
vcpkg\vcpkg.exe install --triplet "x64-windows-static" --x-install-root=vcpkg\installed\windows
vcpkg\vcpkg.exe install --triplet "arm64-android" --x-install-root=vcpkg\installed\android

rem Библиотеки собираются в \packages\...
rem Результат копируется в \installed\...

:EndOfFile

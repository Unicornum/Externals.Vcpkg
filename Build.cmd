@echo off

if "%ANDROID_NDK_HOME%"=="" (
  echo error: not set ANDROID_NDK_HOME
  echo please call first 'setx ANDROID_NDK_HOME path\to\androidndk\root'
  pause
  goto EndOfFile
)

rem Проверить наличие файл-флага
rem if exist .\Vcpkg\installed\windows goto EndOfFile

rem Собрать vcpkg
cd vcpkg
call bootstrap-vcpkg.bat -disableMetrics

cd..

rem Запуск сборки vcpkg.json (x64/ARM64 Debug/Release)
vcpkg\vcpkg.exe install --triplet "x64-windows-static-md" --x-install-root=vcpkg\installed\windows
if ERRORLEVEL 1 (
  echo x64-windows-static-md: error: build failed
  pause
  goto EndOfFile
)

vcpkg\vcpkg.exe install --triplet "arm64-android" --x-install-root=vcpkg\installed\android
if ERRORLEVEL 1 (
  echo arm64-android: error: build failed
  pause
  goto EndOfFile
)

rem Удачная сборка, добавить файл-флаг как маркер этого факта
rem ...

rem Библиотеки собираются в \packages\...
rem Результат копируется в \installed\...

:EndOfFile

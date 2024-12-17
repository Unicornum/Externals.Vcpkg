@echo off

rem [15.12.2024] Корректно собирается для Vs2022 и Android NDK:
set EXPECTED_ANDROID_NDK=android-ndk-r26d

if "%ANDROID_NDK_HOME%"=="" (
  echo error: not set ANDROID_NDK_HOME
  echo please call first 'setx ANDROID_NDK_HOME path\to\androidndk\root'
  pause
  goto EndOfFile
)

call :CheckPathToAndroidNdk "%ANDROID_NDK_HOME%"
if ERRORLEVEL 1 goto EndOfFile

rem Проверить наличие файл-флага
if exist .\vcpkg\Success.build goto EndOfFile

rem Собрать vcpkg
cd vcpkg
call bootstrap-vcpkg.bat -disableMetrics

cd..

rem ================ Можно собирать header only библиотеки в отдельную папку ================

vcpkg\vcpkg.exe install --triplet "x64-windows-static-md" --x-install-root=vcpkg\installed\windows
if ERRORLEVEL 1 (
  echo x64-windows: error: build failed
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
echo Success > .\vcpkg\Success.build

rem Библиотеки собираются в \packages\...
rem Результат копируется в \installed\...

goto EndOfFile

:CheckPathToAndroidNdk

if not "%~nx1" == "%EXPECTED_ANDROID_NDK%" (
  echo ANDROID_NDK_HOME: error: expected path to android-ndk-r26d
  pause
  exit /b 1
)

exit /b 0

:EndOfFile

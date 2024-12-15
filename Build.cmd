@echo off

rem [20.12.2024] Библиотеки корректно собираются для Vs2022 и Android NDK:
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
if exist .\Externals\Success.build goto EndOfFile

rem Собрать vcpkg
cd vcpkg
call bootstrap-vcpkg.bat -disableMetrics

cd..

if exist ..\vcpkg.json (
  set ManifestRoot=--x-manifest-root=..
)

vcpkg\vcpkg.exe install --triplet "x64-windows-static-md" --x-install-root=vcpkg %ManifestRoot%
if ERRORLEVEL 1 (
  echo x64-windows: error: build failed
  pause
  goto EndOfFile
)

rem Копировать в одну общую папку нельзя, .т.к некоторые заголовочные файлы
rem Windows и Android версий отличаются.
xcopy "vcpkg\x64-windows-static-md\*" "Externals\Windows" /S /Q /Y /I

vcpkg\vcpkg.exe install --triplet "arm64-android" --x-install-root=vcpkg %ManifestRoot%
if ERRORLEVEL 1 (
  echo arm64-android: error: build failed
  pause
  goto EndOfFile
)

rem Копировать в одну общую папку нельзя, .т.к некоторые заголовочные файлы
rem Windows и Android версий отличаются.
xcopy "vcpkg\arm64-android\*" "Externals\Android" /S /Q /Y /I

del .\vcpkg\buildtrees\*.* /S /Q

rem Удачная сборка, добавить файл-флаг как маркер этого факта
echo Success > .\Externals\Success.build

rem Библиотеки собираются в \packages\...
rem Результат копируется в \installed\...

goto EndOfFile

:CheckPathToAndroidNdk

if not "%~nx1" == "%EXPECTED_ANDROID_NDK%" (
  echo ANDROID_NDK_HOME: error: expected path to %EXPECTED_ANDROID_NDK%
  pause
  exit /b 1
)

exit /b 0

:EndOfFile

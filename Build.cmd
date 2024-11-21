@echo off

set ANDROID_NDK_HOME=E:\Android\android-ndk-r16b
set PathToResultFile=.\..\ExternalsSDK_v0.0.0.0.7z
set Run7z=.\downloads\tools\7zip-24.08-windows\7za.exe

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

rem Упаковка собранных библиотек в архив SDK
%Run7z% a "%PathToResultFile%" vcpkg.exe .\..\Externals.props -ir!installed\x64-windows-static -ir!installed\arm64-android

pause

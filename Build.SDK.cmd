@echo off

set PathToResultFile=ExternalsSDK_v0.0.0.0.7z
set Run7z=.\vcpkg\downloads\tools\7zip-24.08-windows\7za.exe

call Build.cmd

rem Упаковка собранных библиотек в архив SDK
%Run7z% a "%PathToResultFile%" .\Externals.props -ir!vcpkg\vcpkg.exe -ir!vcpkg\.vcpkg-root -ir!vcpkg\scripts\buildsystems\msbuild -ir!vcpkg\installed\windows\x64-windows-static -ir!vcpkg\installed\android\arm64-android

pause

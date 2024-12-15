@echo off

set PathToResultFile=ExternalsSDK_v0.0.0.0.7z
set Run7z=.\vcpkg\downloads\tools\7zip-24.09-windows\7z.exe

call Build.cmd

rem Упаковка собранных библиотек в архив SDK
%Run7z% a "%PathToResultFile%" -ir!Externals -xr!src -xr!tools
%Run7z% a "%PathToResultFile%" Externals.props
%Run7z% a "%PathToResultFile%" Externals.Android.props

pause

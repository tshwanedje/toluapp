@echo off
setlocal

set "PROJECT=%~dp0tolua++.vcxproj"

set "MSBUILD=MSBuild.exe"
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
    for /f "usebackq tokens=*" %%I in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe`) do (
        set "MSBUILD=%%I"
    )
)

call :Rebuild Debug Win32 || exit /b 1
call :Rebuild Debug x64 || exit /b 1
call :Rebuild Release Win32 || exit /b 1
call :Rebuild Release x64 || exit /b 1
call :Rebuild Debug ARM64 || exit /b 1
call :Rebuild Release ARM64 || exit /b 1

echo.
echo Rebuilt tolua++ static libraries:
if exist "%~dp0Debug\tolua++D-x86.lib" echo   Debug Win32:   "%~dp0Debug\tolua++D-x86.lib"
if exist "%~dp0x64\Debug\tolua++D-x64.lib" echo   Debug x64:     "%~dp0x64\Debug\tolua++D-x64.lib"
if exist "%~dp0ARM64\Debug\tolua++D-arm64.lib" echo   Debug ARM64:   "%~dp0ARM64\Debug\tolua++D-arm64.lib"
if exist "%~dp0Release\tolua++-x86.lib" echo   Release Win32: "%~dp0Release\tolua++-x86.lib"
if exist "%~dp0x64\Release\tolua++-x64.lib" echo   Release x64:   "%~dp0x64\Release\tolua++-x64.lib"
if exist "%~dp0ARM64\Release\tolua++-arm64.lib" echo   Release ARM64: "%~dp0ARM64\Release\tolua++-arm64.lib"

exit /b 0

:Rebuild
echo.
echo Rebuilding tolua++ %~1 %~2...
"%MSBUILD%" "%PROJECT%" /m /t:Rebuild /p:Configuration=%~1 /p:Platform=%~2
exit /b %ERRORLEVEL%

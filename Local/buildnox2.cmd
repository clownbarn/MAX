echo off

REM Initialization
set __NOXHOST=STVNOX
set __NOXBUILDTOOLSDIR=c:\tools\bin\MAX
set __GITREPODIR=C:\Wipro Gallagher Solutions\NetOxygen

echo Launching remote NOX build on %__NOXHOST%...

psexec \\%__NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git fetch --verbose
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)

psexec \\%__NOXHOST% -w %__NOXBUILDTOOLSDIR% buildnoxremote.cmd
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)

goto Fin

:BuildFailed
color 0c
echo BUILD FAILED.
pause
color 0a
exit /b

:Fin
echo Remote NOX build on %__NOXHOST% complete.
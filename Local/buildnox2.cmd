echo off

REM In order to run this script, you must set up the following environment variables:
REM NOXHOST = The machine name of your NOX Server
REM NOXBUILDUSER = The domain user account name you use to log into your NOX Server
REM NOXBUILDPASSWORD = The domain user account password you use to log into your NOX Server.

REM Initialization
set __NOXBUILDTOOLSDIR=c:\tools\bin\MAX
set __GITREPODIR=C:\Wipro Gallagher Solutions\NetOxygen

echo Launching remote NOX build on %__NOXHOST%...

psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git pull --verbose
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)

psexec \\%NOXHOST% -w %__NOXBUILDTOOLSDIR% buildnoxremote.cmd
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
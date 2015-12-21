echo off

REM In order to run this script, you must set up the following environment variables:
REM NOXHOST = The machine name of your NOX Server
REM NOXBUILDUSER = The domain user account name you use to log into your NOX Server
REM NOXBUILDPASSWORD = The domain user account password you use to log into your NOX Server.

REM Initialization
set __NOXBUILDTOOLSDIR=c:\tools\bin\MAX
set __GITREPODIR=C:\Wipro Gallagher Solutions\NetOxygen

echo Launching remote NOX build on %__NOXHOST%...

REM Refresh Project files altered by the NOX .NET Script Compiler.
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Autotasks\Script.AutoTasks.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Controls\Script.Controls.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Defaults\Script.Defaults.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Dialogs\Script.Dialogs.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Dialogs\Script.Dialogs.VB.vbproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Documents\Script.Documents.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Fees\Script.Fees.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\FieldValidation\Script.FieldValidation.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\HotFieldInfo\Script.HotFieldInfo.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Interfaces\Script.Interfaces.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\PaymentStreams\Script.PaymentStreams.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Services\Script.Services.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Shared\Script.Shared.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Shared\Script.Shared.VB.vbproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\Workflow\Script.Workflow.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
psexec \\%NOXHOST% -w "%__GITREPODIR%" -u %NOXBUILDUSER% -p %NOXBUILDPASSWORD% git checkout -- scripts\WorkflowCustom\Script.WorkflowCustom.C#.csproj
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)

REM Get Latest Source.
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
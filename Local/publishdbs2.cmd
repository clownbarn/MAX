@echo off

REM Initialization
set __WORKSPACEDIR=C:\Workspaces\Code\Dev

REM Backup Databases
powershell -command "Invoke-DBBackup -database portal"
powershell -command "Invoke-DBBackup -database pricing"

REM Restart SQL Server
echo Restart SQL Server
net stop MSSQLSERVER
net start MSSQLSERVER

cd /d %__WORKSPACEDIR%

REM Migrate MaxPortal Database
bundle exec rake db:portal:migrate
IF NOT '%ERRORLEVEL%' =='0' (goto DBPublishFailed)

REM Migrate MaxPricing Database
bundle exec rake db:pricing:migrate
IF NOT '%ERRORLEVEL%' =='0' (goto DBPublishFailed)

goto DBPublishComplete

:DBPublishComplete
echo Database publishing complete.
goto Fin

:DBPublishFailed
cmd /c exit %ERRORLEVEL%

:Fin

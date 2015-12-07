REM Copy CMD Files...
ECHO F|xcopy /S /F /R /Y buildmax.cmd C:\Tools\Bin\MAX\buildmax.cmd
ECHO F|xcopy /S /F /R /Y publishdbs2.cmd C:\Tools\Bin\MAX\publishdbs2.cmd
ECHO F|xcopy /S /F /R /Y buildnox2.cmd C:\Tools\Bin\MAX\buildnox2.cmd

REM Copy PowerShell Scripts...
ECHO F|xcopy /S /F /R /Y .\PowerShell\_profile.ps1 C:\Tools\Bin\MAX\PowerShell\_profile.ps1
ECHO F|xcopy /S /F /R /Y .\PowerShell\modules\MAXEX\Invoke-CDE.ps1 C:\Tools\Bin\MAX\PowerShell\modules\MAXEX\Invoke-CDE.ps1
ECHO F|xcopy /S /F /R /Y .\PowerShell\modules\MAXEX\Invoke-DBBackup.ps1 C:\Tools\Bin\MAX\PowerShell\modules\MAXEX\Invoke-DBBackup.ps1
ECHO F|xcopy /S /F /R /Y .\PowerShell\modules\MAXEX\Invoke-LoanStatus.ps1 C:\Tools\Bin\MAX\PowerShell\modules\MAXEX\Invoke-LoanStatus.ps1
ECHO F|xcopy /S /F /R /Y .\PowerShell\modules\MAXEX\Start-BuildMAX.ps1 C:\Tools\Bin\MAX\PowerShell\modules\MAXEX\Start-BuildMAX.ps1
ECHO F|xcopy /S /F /R /Y .\PowerShell\modules\MAXEX\Show-InfoMessage.ps1 C:\Tools\Bin\MAX\PowerShell\modules\MAXEX\Show-InfoMessage.ps1

REM Copy PowerShell Manifest...
ECHO F|xcopy /S /F /R /Y .\PowerShell\modules\MAXEX\MAXEX.psd1 C:\Tools\Bin\MAX\PowerShell\modules\MAXEX\MAXEX.psd1

REM Copy CDE Test Files...
xcopy /S /F /R /Y .\TestCDE\*.* C:\Tools\Bin\TestCDE\MAX*.*
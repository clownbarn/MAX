REM Copy CMD Files...

ECHO WARNING! This is deprecated.  Use junction instead.

ECHO F|xcopy /S /F /R /Y buildnox4dev.cmd C:\Tools\Bin\MAX\buildnox4dev.cmd
ECHO F|xcopy /S /F /R /Y buildnoxlocal.cmd C:\Tools\Bin\MAX\buildnoxlocal.cmd
ECHO F|xcopy /S /F /R /Y buildnoxremote.cmd C:\Tools\Bin\MAX\buildnoxremote.cmd
@echo off

REM Initialization
set __MAXBUILDFAILED=0
set __BUILDTOOLSDIR=C:\tools\bin\MAX
set __USERBUILDTOOLSDIR=%USERPROFILE%\tools\bin
set __WORKSPACEDIR=C:\Workspaces\Code\Dev
set __MAXSOLUTIONPATH=%__WORKSPACEDIR%\Solutions\Max.sln
set __MAXPORTALOUTPUTPATH="%__WORKSPACEDIR%\Web Applications\Max.UI.Portal\bin\Max.UI.Portal.dll"

REM Reset IIS
echo Resetting IIS...
iisreset

REM Fetch latest source from TFS
echo Getting latest from TFS...
tf get "$/MAX/Code/Dev" /recursive /all
IF NOT '%ERRORLEVEL%' =='0' (
	IF '%ERRORLEVEL%' =='1' (
		REM Indicates TFS GET partial success.  Carry on.
		set __MAXBUILDFAILED=0
	) ELSE (
		set __MAXBUILDFAILED=1
	)
)
IF %__MAXBUILDFAILED% == 1 (goto BuildFailed)

REM Publish databases
echo Publishing databases...
REM call %__BUILDTOOLSDIR%\publishdbs2.cmd
call %__BUILDTOOLSDIR%\publishdbs2.cmd
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
echo Database publishing complete.

REM Build Max Portal solution 
echo Building Max Portal Solution...
devenv %__MAXSOLUTIONPATH% /clean
devenv %__MAXSOLUTIONPATH% /build debug
IF NOT EXIST %__MAXPORTALOUTPUTPATH% (goto BuildFailed)
echo Max Portal Solution Build complete.

REM Build NOX interpreter scripts and MaxPortalServices
echo Performing NOX build step...
REM call buildnox2.cmd
call %__BUILDTOOLSDIR%\buildnox2.cmd
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
echo NOX build step complete.
goto BuildFinished

:BuildFinished
echo BUILD FINISHED.
goto Fin

:BuildFailed
color 0c
echo BUILD FAILED.
pause
color 0a

:Fin
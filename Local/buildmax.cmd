@echo off

REM Initialization
set __MAXBUILDFAILED=0
set __BUILDTOOLSDIR=C:\tools\bin
set __USERBUILDTOOLSDIR=%USERPROFILE%\tools\bin
set __WORKSPACEDIR=C:\Workspaces\Code\Dev
set __DOCGENSOLUTIONPATH="%__WORKSPACEDIR%\Application Layer\Max.Business.DocumentGenerator\Max.Business.DocumentGenerator.sln"
set __DOCGENOUTPUTPATH="%__WORKSPACEDIR%\Application Layer\Max.Business.DocumentGenerator\bin\Debug\Max.Business.DocumentGenerator.exe"
set __MAXSOLUTIONPATH=%__WORKSPACEDIR%\Solutions\Max.sln
set __MAXPORTALOUTPUTPATH="%__WORKSPACEDIR%\Web Applications\Max.UI.Portal\bin\Max.UI.Portal.dll"
set __PRICINGDATAPROJECTPATH=%__WORKSPACEDIR%\PricingService\Max.Database.PricingService\Max.Database.PricingService.sqlproj
set __PRICINGDATAOUTPUTPATH=%__WORKSPACEDIR%\PricingService\Max.Database.PricingService\bin\Output\Max.Database.PricingService.dacpac
set __MAXDATAPROJECTPATH=%__WORKSPACEDIR%\Data\Max.Database\Max.Database.Schema.sqlproj
set __MAXDATAOUTPUTPATH=%__WORKSPACEDIR%\Data\Max.Database\bin\Output\Max.Database.Schema.dacpac


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

REM Build Document Generator Solution
echo Building Document Generator Solution...
devenv %__DOCGENSOLUTIONPATH% /clean
devenv %__DOCGENSOLUTIONPATH% /build debug
IF NOT EXIST %__DOCGENOUTPUTPATH% (goto BuildFailed)
echo Document Generator Solution Build complete.

REM Build Max Portal solution 
echo Building Max Portal Solution...
devenv %__MAXSOLUTIONPATH% /clean
devenv %__MAXSOLUTIONPATH% /project %__PRICINGDATAPROJECTPATH% /build debug
IF NOT EXIST %__PRICINGDATAOUTPUTPATH% (goto BuildFailed)
devenv %__MAXSOLUTIONPATH% /project %__MAXDATAPROJECTPATH% /build debug
IF NOT EXIST %__MAXDATAOUTPUTPATH% (goto BuildFailed)
devenv %__MAXSOLUTIONPATH% /build debug
IF NOT EXIST %__MAXPORTALOUTPUTPATH% (goto BuildFailed)
echo Max Portal Solution Build complete.

REM Publish databases
echo Publishing databases...
REM call %__BUILDTOOLSDIR%\publishdbs2.cmd
call %__BUILDTOOLSDIR%\publishdbs2.cmd
IF NOT '%ERRORLEVEL%' =='0' (goto BuildFailed)
echo Database publishing complete.

REM Build NOX interpreter scripts and MaxPortalServices
echo Performing NOX build step...
REM call %__USERBUILDTOOLSDIR%\buildnox2.cmd
call %__USERBUILDTOOLSDIR%\buildnox2.cmd
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
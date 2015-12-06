@echo off

REM Initialization
set __OUTPUTDIR=C:\Wipro Gallagher Solutions\NetOxygen\ScriptAssemblies\
set __WORKSPACEDIR=C:\Workspaces\MAX\Code\Dev
set __MAXPORTALSERVICESPROJECTPATH=%__WORKSPACEDIR%\Net Oxygen\Server\Services\MaxPortalServices\MaxPortalServices.csproj

REM Kill GFXServer
echo Killing GFXServer...
pskill GFXServer.exe

REM Reset IIS
echo Resetting IIS...
iisreset

REM "Clean"
echo Cleaning output directory...
del "%__OUTPUTDIR%*.dll"

REM Build Interpreter Scripts
echo Building interpreter scripts...
DotNetScriptCompiler.exe /Rebuild
IF NOT EXIST "%__OUTPUTDIR%Script.Shared.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Shared.VB.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Defaults.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Workflow.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.WorkflowCustom.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Autotasks.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Controls.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Fees.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Interfaces.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Dialogs.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Dialogs.VB.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Documents.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.HotFieldInfo.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.PaymentStreams.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.Services.C#.dll" (goto NoxBuildFailed)
IF NOT EXIST "%__OUTPUTDIR%Script.FieldValidation.C#.dll" (goto NoxBuildFailed)
echo Interpreter script build complete.

REM Build and Publish MAX Portal Services
echo Building and Publishing MAX Portal Services...
msbuild "%__MAXPORTALSERVICESPROJECTPATH%" /p:VisualStudioVersion=12.0
echo MAX Portal Services build and publish complete.
goto NoxBuildComplete

:NoxBuildComplete
echo NOX build complete
goto Fin

:NoxBuildFailed
cmd /b exit 999

:Fin

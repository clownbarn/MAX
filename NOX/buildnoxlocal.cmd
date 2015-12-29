REM Get's the latest source from TFS and builds NOX locally.

REM Initialization
set __OUTPUTDIR=C:\Wipro Gallagher Solutions\NetOxygen\ScriptAssemblies\

echo Getting latest from TFS...

cd "C:\Wipro Gallagher Solutions\NetOxygen"

REM Refresh Project files altered by the NOX .NET Script Compiler
git checkout -- scripts\Autotasks\Script.AutoTasks.C#.csproj
git checkout -- scripts\Controls\Script.Controls.C#.csproj
git checkout -- scripts\Defaults\Script.Defaults.C#.csproj
git checkout -- scripts\Dialogs\Script.Dialogs.C#.csproj
git checkout -- scripts\Dialogs\Script.Dialogs.VB.vbproj
git checkout -- scripts\Documents\Script.Documents.C#.csproj
git checkout -- scripts\Fees\Script.Fees.C#.csproj
git checkout -- scripts\FieldValidation\Script.FieldValidation.C#.csproj
git checkout -- scripts\HotFieldInfo\Script.HotFieldInfo.C#.csproj
git checkout -- scripts\Interfaces\Script.Interfaces.C#.csproj
git checkout -- scripts\PaymentStreams\Script.PaymentStreams.C#.csproj
git checkout -- scripts\Services\Script.Services.C#.csproj
git checkout -- scripts\Shared\Script.Shared.C#.csproj
git checkout -- scripts\Shared\Script.Shared.VB.vbproj
git checkout -- scripts\Workflow\Script.Workflow.C#.csproj
git checkout -- scripts\WorkflowCustom\Script.WorkflowCustom.C#.csproj

REM Get Latest Source.
git pull --verbose

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

echo Building MAX Portal Services...
msbuild "C:\Workspaces\MAX\Code\Dev\Net Oxygen\Server\Services\MaxPortalServices\MaxPortalServices.csproj" /p:VisualStudioVersion=12.0

echo NOX build complete
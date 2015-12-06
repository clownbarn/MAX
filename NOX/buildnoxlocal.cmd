REM Get's the latest source from TFS and builds NOX locally.

echo "Getting latest from TFS..."

cd "C:\Wipro Gallagher Solutions\NetOxygen"
git fetch --verbose

echo "Building interpreter scripts"
DotNetScriptCompiler.exe /Rebuild
pskill GFXServer.exe
iisreset

echo "Building MAX Portal Services..."
msbuild "C:\Workspaces\MAX\Code\Dev\Net Oxygen\Server\Services\MaxPortalServices\MaxPortalServices.csproj" /p:VisualStudioVersion=12.0

echo "NOX build complete"
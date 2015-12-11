REM Builds NOX locally without fetch source from TFS.  For use in development.

echo Building interpreter scripts
DotNetScriptCompiler.exe /Rebuild
pskill GFXServer.exe
iisreset

echo Building MAX Portal Services...
msbuild "C:\Workspaces\MAX\Code\Dev\Net Oxygen\Server\Services\MaxPortalServices\MaxPortalServices.csproj" /p:VisualStudioVersion=12.0

echo NOX build complete
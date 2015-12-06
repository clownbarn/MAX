Function Start-BuildMAX
{
    Begin
    {
        <#
            Helper function to show information message.
        #>
        Function Show-Info-Message($msg)
        {
            Write-Host $msg -ForegroundColor White
        }
    }
    Process
    {
        Show-Info-Message "Starting MAX Build"

        $command = "cmd /c c:\tools\bin\buildmax.cmd"

        Invoke-Expression -Command:$command

    }
}

#export-modulemember -function Start-BuildMAX

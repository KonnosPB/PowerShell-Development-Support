<#
.SYNOPSIS
This function updates the bearer token used for authentication when making requests to a DevSuite.

.DESCRIPTION
The Update-DevSuiteBearerToken function updates the bearer token used for authentication when making requests to a DevSuite. The function initiates a process to start the bearer token application. Once the application has exited, the function retrieves the newly updated bearer token and sets it as the global DevSuiteBearerToken. 

.PARAMETER BearerTokenApplication
The BearerTokenApplication parameter is a mandatory string parameter that specifies the name of the bearer token application.

.EXAMPLE
Update-DevSuiteBearerToken -BearerTokenApplication "c:\temp\BearerTokenApp.exe"

This example initiates the "BearerTokenApp" application and updates the global DevSuiteBearerToken with the token retrieved from the application.
#>
function Update-DevSuiteBearerToken {
    Param (       
        [Parameter(Mandatory = $true)]
        [string] $BearerTokenApplication
    )
    $bearerTokenApplicationProcess = Start-Process $BearerTokenApplication -ArgumentList "-u https://devsuite.kumavision.de", "-e $($Global:Config.EnvVarDevSuiteBearerToken)", "--autoclose" -PassThru
    $bearerTokenApplicationProcess.WaitForExit() 
    $Global:DevSuiteBearerToken = [System.Environment]::GetEnvironmentVariable($Global.Config.EnvVarDevSuiteBearerToken, "User")   
    return $Global:DevSuiteBearerToken
}
Export-ModuleMember -Function Update-DevSuiteBearerToken
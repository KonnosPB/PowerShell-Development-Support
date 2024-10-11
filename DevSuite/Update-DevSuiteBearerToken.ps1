<#
.SYNOPSIS
This function updates the bearer token used for authentication when making requests to a DevSuite.

.DESCRIPTION
The Update-DevSuiteBearerToken function updates the bearer token used for authentication when making requests to a DevSuite. The function initiates a process to start the bearer token application. Once the application has exited, the function retrieves the newly updated bearer token and sets it as the global DevSuiteBearerToken. 

.EXAMPLE
Update-DevSuiteBearerToken -BearerTokenApplication "c:\temp\BearerTokenApplication.exe"

This example initiates the "BearerTokenApp" application and updates the global DevSuiteBearerToken with the token retrieved from the application.
#>
function Update-DevSuiteBearerToken {    
    $envBearerToken = $Global:Config.EnvVarDevSuiteBearerToken
    $process = $Global:BearerTokenApplicationPath
    $argumentList = @("-u https://devsuite.kumavision.de", "-e $envBearerToken", "--autoclose")
    $bearerTokenApplicationProcess = Start-Process $process -ArgumentList $argumentList -PassThru
    $bearerTokenApplicationProcess.WaitForExit() 
    $Global:DevSuiteBearerToken = [System.Environment]::GetEnvironmentVariable($envBearerToken, "User")
    return $Global:DevSuiteBearerToken
}

Export-ModuleMember -Function Update-DevSuiteBearerToken
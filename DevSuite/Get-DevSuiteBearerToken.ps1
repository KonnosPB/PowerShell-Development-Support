<#
.SYNOPSIS
This function retrieves the current DevSuite Bearer token.

.DESCRIPTION
The Get-DevSuiteBearerToken function checks if the current token stored in the $Global:DevSuiteBearerToken is valid using the Test-DevSuiteBearerToken function. If the token is not valid, it updates the token using the Update-DevSuiteBearerToken function. The function then returns the current token.

.PARAMETER Global:DevSuiteBearerToken
This parameter represents the current Bearer token. It is tested for validity and updated if necessary.

.EXAMPLE
Get-DevSuiteBearerToken

This command retrieves the current DevSuite Bearer token. If the token is not valid, it is updated before being returned.

#>
function Get-DevSuiteBearerToken {    
    if (-not (Test-DevSuiteBearerToken -BearerToken $Global:DevSuiteBearerToken)) {
        $Global:DevSuiteBearerToken = Update-DevSuiteBearerToken
    }
    return $Global:DevSuiteBearerToken
}
Export-ModuleMember -Function Get-DevSuiteBearerToken 
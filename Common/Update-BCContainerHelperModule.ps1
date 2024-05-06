# https://github.com/HarmVeenstra/Powershellisfun/blob/main/Update%20all%20PowerShell%20Modules/Update-Modules.ps1
function Update-BCContainerHelperModule {
	param (
		[switch]$AllowPrerelease,
		[switch]$WhatIf
	)

	Update-BCContainerHelperModule -Name "BcContainerHelper" -AllowPrerelease:$AllowPrerelease 		
}

Export-ModuleMember -Function  Update-BCContainerHelperModule
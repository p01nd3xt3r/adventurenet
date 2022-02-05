<#
.Synopsis
.Description
.Parameter Text
.Example 
.Inputs
.Outputs
.Notes
.Link
.Component
.Role
.Functionality
#>
Function Get-AVNStatus {
    #Writes current health levels and the last host output the player had to the screen.
    #Do a type param for each different category, and if no type is chosen, show all.
    Get-AVNConfig
    
    #These are just placeholders. I plan to make this pretty.
    Write-Host '$global:AVNPlayerDataCommon' -foregroundcolor $global:AVNDefaultTextForegroundColor
    $global:AVNPlayerDataCommon
    Write-Host ""
    Write-Host '$global:AVNCompanyDataCommon' -foregroundcolor $global:AVNDefaultTextForegroundColor
    $global:AVNCompanyDataCommon
    Write-Host ""
    Write-Host '$global:AVNCompanyData_CurrentPlayer' -foregroundcolor $global:AVNDefaultTextForegroundColor
    $global:AVNCompanyData_CurrentPlayer
    Write-Host ""
    Write-Host '$global:AVNPlayerData_CurrentPlayer' -foregroundcolor $global:AVNDefaultTextForegroundColor
    $global:AVNPlayerData_CurrentPlayer
    Write-Host ""
    Write-Host "Service Tickets               " $global:AVNServiceTickets_CurrentPlayer.count "`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
    Write-Host '$global:AVNPlayerData_CurrentPlayer.lastsignon' -foregroundcolor $global:AVNDefaultTextForegroundColor
    $global:AVNPlayerData_CurrentPlayer.lastsignon
    Write-Host ""
    Write-Host '$global:AVNDicePerm_CurrentPlayer' -foregroundcolor $global:AVNDefaultTextForegroundColor
    $global:AVNDicePerm_CurrentPlayer
    Write-Host ""
    Write-Host '$global:AVNDiceDaily_CurrentPlayer' -foregroundcolor $global:AVNDefaultTextForegroundColor
    $global:AVNDiceDaily_CurrentPlayer
}
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
    param (
        [Parameter()][switch]$Dev
    )
    #Writes current health levels and the last host output the player had to the screen.
    #Do a type param for each different category, and if no type is chosen, show all.
    Get-AVNConfig
    
    If ($False -eq $Dev) {
        
    } Else {
        Write-Host "`$global:AVNPlayerDataCommon" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNPlayerDataCommon
        Write-Host "`n`$global:AVNCompanyDataCommon" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNCompanyDataCommon
        Write-Host "`n`$global:AVNCompanyData_CurrentPlayer" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNCompanyData_CurrentPlayer
        Write-Host "`n`$global:AVNPlayerData_CurrentPlayer" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNPlayerData_CurrentPlayer
        Write-Host "`nService Tickets               " $global:AVNServiceTickets_CurrentPlayer.count -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "`n`$global:AVNPlayerData_CurrentPlayer.lastsignon" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNPlayerData_CurrentPlayer.lastsignon
        Write-Host "`n`$global:AVNDicePerm_CurrentPlayer" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNDicePerm_CurrentPlayer
        Write-Host "`n`$global:AVNDiceDaily_CurrentPlayer" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNDiceDaily_CurrentPlayer
        Write-Host "`n`$global:AVNSpecials_CurrentPlayer" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNSpecials_CurrentPlayer
    }
}
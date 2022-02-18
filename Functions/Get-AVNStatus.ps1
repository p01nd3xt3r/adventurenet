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
    
    #Temp until I format the non-dev version
    $Dev = $True

    If ($False -eq $Dev) {
        
    } Else {
        $global:AVNCompanyDataCommon
        $global:AVNCompanyData_CurrentPlayer
        $global:AVNPlayerData_CurrentPlayer
        Write-Host "`nService Tickets               " $global:AVNServiceTickets_CurrentPlayer.count -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNPlayerData_CurrentPlayer.lastsignon
        $global:AVNDicePerm_CurrentPlayer
        $global:AVNDiceDaily_CurrentPlayer
        $global:AVNSpecials_CurrentPlayer

        $AVNPlayerTable = @(
            ForEach ($AVNPlayer in $global:AVNPlayerDataCommon) {
                $AVNPlayerProperties = @{
                    Player = $AVNPlayer.playername
                    Global = $AVNPlayer.globalnotice
                    Kudos = $AVNPlayer.kudos
                }
                New-Object psobject -property $AVNPlayerProperties
            }
        )
        $AVNPlayerTable | Format-Table player,global,kudos | Sort-Object -property "kudos" -descending
    }
}
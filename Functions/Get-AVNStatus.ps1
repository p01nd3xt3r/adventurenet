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
        [Parameter()][string]$Type = ""
    )
    #Writes current health levels and the last host output the player had to the screen.
    #Do a type param for each different category, and if no type is chosen, show all?
    Get-AVNConfig

    If ($Type -eq "") {
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

        Write-Host "`nTeam Stats" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Team Health:                     " $global:AVNCompanyDataCommon.teamhealth "out of" $global:AVNHealthDefault
        Write-Host "Client Health:                   " $global:AVNCompanyDataCommon.clienthealth "out of" $global:AVNHealthDefault
        Write-Host "Current Project Stage:           " $global:AVNCompanyDataCommon.currentstage
        Write-Host "Technical Questions:             " $global:AVNCompanyDataCommon.technicalquestionstotal

        Write-Host "`nYour Stats" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Player Name:                     " $global:AVNPlayerData_CurrentPlayer.playername
        Write-Host "GIFs:                            " $global:AVNPlayerData_CurrentPlayer.gifs
        Write-Host "Training Available:              " $global:AVNPlayerData_CurrentPlayer.training
        Write-Host "Project Stage Attempts Available:" ($global:AVNProjectStageDailyAllowance - $global:AVNPlayerData_CurrentPlayer.projectstageattempts)
        Write-Host "Service Tickets:                 " $global:AVNServiceTickets_CurrentPlayer.count
        Write-Host "Turns Available:                 " $global:AVNPlayerData_CurrentPlayer.turns
        Write-Host "Opportunities Available:         " $global:AVNPlayerData_CurrentPlayer.opportunities
        Write-Host "Technical Questions Available:   " $global:AVNCompanyDataCommon.technicalquestionsavailable
        Write-Host "Last Sign On:                    " $global:AVNPlayerData_CurrentPlayer.lastsignon

        $AVNDiceTable = @(
            ForEach ($AVNPermDice in $global:AVNDicePerm_CurrentPlayer) {
                $AVNPermDiceProperties = @{
                    Dice = $AVNPermDice
                    Type = "Permanent"
                }
                New-Object psobject -property $AVNPermDiceProperties
            }
            ForEach ($AVNDailyDice in $global:AVNDiceDaily_CurrentPlayer) {
                $AVNDailyDiceProperties = @{
                    Dice = $AVNDailyDice
                    Type = "Daily"
                }
                New-Object psobject -property $AVNDailyDiceProperties
            }
        )
        $AVNDiceTable | Format-Table Dice,Type | Sort-Object -property "Dice"
        
        #Getting specials
        #Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
        $AVNDataFileContent | ForEach-Object {
        Invoke-Expression $_
        }

        $AVNSpecialsTable = @(
            ForEach ($AVNOwnedSpecial in $global:AVNSpecials_CurrentPlayer) {
                $AVNDecipheredSpecial = $AVNSpecials | Where-Object {$_.name -eq $AVNOwnedSpecial}
                $AVNOwnedSpecialProperties = @{
                    Specials = $AVNOwnedSpecial
                    Type = $AVNDecipheredSpecial.type
                    Description = $AVNDecipheredSpecial.description
                }
                New-Object psobject -property $AVNOwnedSpecialProperties
            }
        )
        $AVNSpecialsTable | Format-Table Specials,Type,Description | Sort-Object -property "Specials"
    } ElseIf ($Type -eq "historical") {
        #Really, this should show for all players.
        Write-Host "`nHistorical Stats" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Recent Client Health Contributions:  " $global:AVNHistoricalData_CurrentPlayer.RecentClientHealthContributions
        Write-Host "Recent Team Health Contributions:    " $global:AVNHistoricalData_CurrentPlayer.RecentTeamHealthContributions
        Write-Host "Recent Project Stage Waves Completed:" $global:AVNHistoricalData_CurrentPlayer.RecentProjectStageWavesCompleted
        Write-Host "Recent Kudos Attained:               " $global:AVNHistoricalData_CurrentPlayer.RecentKudos
        Write-Host "Recent GIFs Attained:                " $global:AVNHistoricalData_CurrentPlayer.RecentGIFs
        Write-Host "Total Client Health Contributions:   " $global:AVNHistoricalData_CurrentPlayer.TotalClientHealthContributions
        Write-Host "Total Team Health Contributions:     " $global:AVNHistoricalData_CurrentPlayer.TotalTeamHealthContributions
        Write-Host "Total Project Stage Waves Completed: " $global:AVNHistoricalData_CurrentPlayer.TotalProjectStageWavesCompleted
        Write-Host "Total Kudos Attained:                " $global:AVNHistoricalData_CurrentPlayer.TotalKudos
        Write-Host "Total GIFs Attained:                 " $global:AVNHistoricalData_CurrentPlayer.TotalGIFs "`n"
    } ElseIf ($Type -eq "dev") {
        '`n$global:AVNSpecials_CurrentPlayer'
        $global:AVNSpecials_CurrentPlayer
        '`n$global:AVNDicePerm_CurrentPlayer'
        $global:AVNDicePerm_CurrentPlayer
        '`n$global:AVNDiceDaily_CurrentPlayer'
        $global:AVNDiceDaily_CurrentPlayer
        "`nService Tickets:" 
        $global:AVNServiceTickets_CurrentPlayer.count
        '`n$global:AVNPlayerData_CurrentPlayer'
        $global:AVNPlayerData_CurrentPlayer
        '`n$global:AVNPlayerData_CurrentPlayer'
        $global:AVNPlayerData_CurrentPlayer
        '`n$global:AVNCompanyDataCommon'
        $global:AVNCompanyDataCommon
        '`n$global:AVNHistoricalData_CurrentPlayer'
        $global:AVNHistoricalData_CurrentPlayer
    } Else {
        Write-Host "`nSorry, you've entered an invalid -type. Try again without using -type or else using either -type 'dev' or 'historical'.`n"
    }
}
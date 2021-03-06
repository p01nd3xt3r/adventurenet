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
        [Parameter()][switch]$Scoreboard,
        [Parameter()][switch]$Team,
        [Parameter()][switch]$Player,
        [Parameter()][switch]$Inventory,
        [Parameter()][switch]$Historical,
        [Parameter()][switch]$Dev
    )
    #Writes current health levels and the last host output the player had to the screen.
    Get-AVNConfig

    If (($False -eq $Scoreboard) -and ($False -eq $Team) -and ($False -eq $Player) -and ($False -eq $Inventory) -and ($False -eq $Historical) -and ($False -eq $Dev)) {
        $Scoreboard = $True
        $Team = $True
        $Player = $True
        $Inventory = $True
    }

    If ($True -eq $Scoreboard) {
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
        Write-Host "`n⣿ADVENTURENET⣿ Scoreboard ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNPlayerTable | Sort-Object kudos,player -descending | Format-Table player,global,kudos
    }
    If ($True -eq $Team) {
        Write-Host "`n⣿ADVENTURENET⣿ Team Stats ⣿`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Team Health:                      " $global:AVNCompanyDataCommon.teamhealth "out of" $global:AVNHealthDefault
        Write-Host "Daily Team Health Penalty Level:  " $global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel
        Write-Host "Client Health:                    " $global:AVNCompanyDataCommon.clienthealth "out of" $global:AVNHealthDefault
        Write-Host "Daily Client Health Penalty Level:" $global:AVNCompanyData_CurrentPlayer.clienthealthpenaltylevel
        Write-Host "Current Project Stage:            " $global:AVNCompanyDataCommon.currentstage
        If ($global:AVNCompanyDataCommon.currentstage -eq 1) {
            $AVNCurrentProjectDeadline = (Get-Date $global:AVNProjectStage1Deadline).date
        } ElseIf ($global:AVNCompanyDataCommon.currentstage -eq 2) {
            $AVNCurrentProjectDeadline = (Get-Date $global:AVNProjectStage2Deadline).date
        } ElseIf ($global:AVNCompanyDataCommon.currentstage -eq 3) {
            $AVNCurrentProjectDeadline = (Get-Date $global:AVNProjectStage3Deadline).date
        }
        Write-Host "Current Project Stage Deadline:   " $AVNCurrentProjectDeadline
        If ($global:AVNCompanyDataCommon.currentstage -eq 1) {
            Write-Host "Remaining Project Stage Blocs:    " $global:AVNCompanyDataCommon.ProjectStage1BlocsRemaining
        } ElseIf ($global:AVNCompanyDataCommon.currentstage -eq 2) {
            Write-Host "Remaining Project Stage Blocs:    " $global:AVNCompanyDataCommon.ProjectStage2BlocsRemaining
        } ElseIf ($global:AVNCompanyDataCommon.currentstage -eq 3) {
            Write-Host "Remaining Project Stage Blocs:    " $global:AVNCompanyDataCommon.ProjectStage3BlocsRemaining
        }
        Write-Host "Technical Questions:              " $global:AVNCompanyDataCommon.technicalquestionstotal


        If ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -eq 5) {
            Write-Host "`nAs a result of low Team Health, the following penalties have been applied:`n- Daily Dice randomly assigned`n- Training requires GIFs`n- Increased risk of Project counterattacks`n- Reduction in chance of finding Specials in Service Tickets`n- Permanent dice randomly assigned in Training" -foregroundcolor $global:AVNDefaultTextForegroundColor
        } ElseIf ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -eq 4) {
            Write-Host "`nAs a result of low Team Health, the following penalties have been applied:`n- Daily Dice randomly assigned`n- Training requires GIFs`n- Increased risk of Project counterattacks`n- Reduction in chance of finding Specials in Service Tickets" -foregroundcolor $global:AVNDefaultTextForegroundColor
        } ElseIf ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -eq 3) {
            Write-Host "`nAs a result of low Team Health, the following penalties have been applied:`n- Daily Dice randomly assigned`n- Training requires GIFs`n- Increased risk of Project counterattacks" -foregroundcolor $global:AVNDefaultTextForegroundColor
        } ElseIf ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -eq 2) {
            Write-Host "`nAs a result of low Team Health, the following penalties have been applied:`n- Daily Dice randomly assigned`n- Training requires GIFs" -foregroundcolor $global:AVNDefaultTextForegroundColor
        } ElseIf ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -eq 1) {
            Write-Host "`nAs a result of low Team Health, the following penalty has been applied:`n- Daily Dice randomly assigned" -foregroundcolor $global:AVNDefaultTextForegroundColor
        }

        If ($global:AVNCompanyData_CurrentPlayer.clienthealthpenaltylevel -eq 5) {
            Write-Host "`nAs a result of low Client Health, the following penalties have been applied:`n- Use three fewer dice per Service Ticket encounter`n- Closing Technical Questions requires GIFs and an additional turn" -foregroundcolor $global:AVNDefaultTextForegroundColor
        } ElseIf ($global:AVNCompanyData_CurrentPlayer.clienthealthpenaltylevel -eq 4) {
            Write-Host "`nAs a result of low Client Health, the following penalties have been applied:`n- Use two fewer dice per Service Ticket encounter`n- Closing Technical Questions requires GIFs and an additional turn" -foregroundcolor $global:AVNDefaultTextForegroundColor
        } ElseIf ($global:AVNCompanyData_CurrentPlayer.clienthealthpenaltylevel -eq 3) {
            Write-Host "`nAs a result of low Client Health, the following penalties have been applied:`n- Use two fewer dice per Service Ticket encounter`n- Closing Technical Questions requires GIFs" -foregroundcolor $global:AVNDefaultTextForegroundColor
        } ElseIf ($global:AVNCompanyData_CurrentPlayer.clienthealthpenaltylevel -eq 2) {
            Write-Host "`nAs a result of low Client Health, the following penalties have been applied:`n- Use one fewer die per Service Ticket encounter`n- Closing Technical Questions requires GIFs" -foregroundcolor $global:AVNDefaultTextForegroundColor
        } ElseIf ($global:AVNCompanyData_CurrentPlayer.clienthealthpenaltylevel -eq 1) {
            Write-Host "`nAs a result of low Client Health, the following penalty has been applied:`n- Use one fewer die per Service Ticket encounter" -foregroundcolor $global:AVNDefaultTextForegroundColor
        }
    }
    If ($True -eq $Player) {
        Write-Host "`n`n⣿ADVENTURENET⣿ Player Stats ⣿`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Player Name:                      " $global:AVNPlayerData_CurrentPlayer.playername
        Write-Host "GIFs:                             " $global:AVNPlayerData_CurrentPlayer.gifs
        Write-Host "Training Available:               " $global:AVNPlayerData_CurrentPlayer.training
        Write-Host "Project Bloc Attempts Available:  " ($global:AVNProjectBlocDailyAllowance - $global:AVNPlayerData_CurrentPlayer.projectblocattempts)
        Write-Host "Service Tickets:                  " $global:AVNServiceTickets_CurrentPlayer.count
        Write-Host "Turns Available:                  " $global:AVNPlayerData_CurrentPlayer.turns
        Write-Host "Opportunities Available:          " $global:AVNPlayerData_CurrentPlayer.opportunities
        Write-Host "Technical Questions Available:    " $global:AVNCompanyDataCommon.technicalquestionsavailable
        Write-Host "Last Sign On:                     " $global:AVNPlayerData_CurrentPlayer.lastsignon
    }
    If ($True -eq $Inventory) {
        $AVNDiceTable = @(
            ForEach ($AVNPermDice in $global:AVNDicePerm_CurrentPlayer) {
                $AVNPermDiceProperties = [ordered]@{
                    Dice = $AVNPermDice
                    Type = "Permanent"
                }
                New-Object psobject -property $AVNPermDiceProperties
            }
            ForEach ($AVNDailyDice in $global:AVNDiceDaily_CurrentPlayer) {
                $AVNDailyDiceProperties = [ordered]@{
                    Dice = $AVNDailyDice
                    Type = "Daily"
                }
                New-Object psobject -property $AVNDailyDiceProperties
            }
        )
        Write-Host "`n`n⣿ADVENTURENET⣿ Inventory ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNDiceTable | Sort-Object dice,type | Format-Table Dice,Type
        
        #Getting specials
        #Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
        $AVNDataFileContent | ForEach-Object {
        Invoke-Expression $_
        }

        $global:AVNSpecialsTable = @(
            ForEach ($AVNOwnedSpecial in $global:AVNSpecials_CurrentPlayer) {
                $AVNDecipheredSpecial = $AVNSpecials | Where-Object {$_.name -eq $AVNOwnedSpecial}
                $AVNOwnedSpecialProperties = [ordered]@{
                    Specials = $AVNOwnedSpecial
                    Type = $AVNDecipheredSpecial.type
                    Effect = $AVNDecipheredSpecial.effectdescription
                    Count = 1
                }
                New-Object psobject -property $AVNOwnedSpecialProperties
            }
        )
        #Old. The below script rolls it up and displays a count for each. Write-Output $global:AVNSpecialsTable | Sort-Object type,specials | Format-Table Specials,Type,Effect
        $AVNSpecialsTableRolled = @()
        $AVNSpecialsTableRolledTracker = @()
        ForEach ($AVNSpecialsTableSpecial in $global:AVNSpecialsTable) {
            If ($AVNSpecialsTableSpecial.specials -notin $AVNSpecialsTableRolledTracker) {
                $AVNSpecialsTableRolled += $AVNSpecialsTableSpecial
                $AVNSpecialsTableRolledTracker += $AVNSpecialsTableSpecial.specials
            } Else {
                ForEach ($AVNSpecialsTableRolledSpecial in $AVNSpecialsTableRolled) {
                    If ($AVNSpecialsTableSpecial.specials -eq $AVNSpecialsTableRolledSpecial.specials) {
                        $AVNSpecialsTableRolledSpecial.count += 1
                    }
                }
            }
        }
        Write-Output $AVNSpecialsTableRolled | Sort-Object type,specials | Format-Table Specials,Count,Type,Effect
        
    }
    If ($True -eq $Historical) {
        #Really, this should show for all players.
        Write-Host "`n⣿ADVENTURENET⣿ Historical Stats ⣿`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Recent Client Health Contributions:  " $global:AVNHistoricalData_CurrentPlayer.RecentClientHealthContributions
        Write-Host "Recent Team Health Contributions:    " $global:AVNHistoricalData_CurrentPlayer.RecentTeamHealthContributions
        Write-Host "Recent Project Stage Blocs Completed:" $global:AVNHistoricalData_CurrentPlayer.RecentProjectStageBlocsCompleted
        Write-Host "Recent Kudos Attained:               " $global:AVNHistoricalData_CurrentPlayer.RecentKudos
        Write-Host "Recent GIFs Attained:                " $global:AVNHistoricalData_CurrentPlayer.RecentGIFs
        Write-Host "Total Client Health Contributions:   " $global:AVNHistoricalData_CurrentPlayer.TotalClientHealthContributions
        Write-Host "Total Team Health Contributions:     " $global:AVNHistoricalData_CurrentPlayer.TotalTeamHealthContributions
        Write-Host "Total Project Stage Blocs Completed: " $global:AVNHistoricalData_CurrentPlayer.TotalProjectStageBlocsCompleted
        Write-Host "Total Kudos Attained:                " $global:AVNHistoricalData_CurrentPlayer.TotalKudos
        Write-Host "Total GIFs Attained:                 " $global:AVNHistoricalData_CurrentPlayer.TotalGIFs "`n"
    }
    If ($Type -eq "dev") {
        Write-Host "`n⣿ADVENTURENET⣿ Dev ⣿`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
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
    }
}
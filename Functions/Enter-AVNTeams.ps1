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
Function Enter-AVNTeams {
    Get-AVNConfig

    Write-Host "`n    ████████ ███████  █████  ███    ███ ███████                               `n       ██    ██      ██   ██ ████  ████ ██                                    `n       ██    █████   ███████ ██ ████ ██ ███████                               `n       ██    ██      ██   ██ ██  ██  ██      ██                               `n       ██    ███████ ██   ██ ██      ██ ███████                               `n`n" -foregroundcolor $global:AVNDefaultBannerForegroundColor
    Write-Host "`nWelcome to Teams, where you can convert your GIFs into powerful specials." -foregroundcolor $global:AVNDefaultTextForegroundColor
    Wait-AVNKeyPress

    $AVNTeamsSpecials = [ordered]@{'?' = 'Show information about your options.'}
    [int]$AVNTeamsSpecialsI = 0
    $AVNSpecials | ForEach-Object {
        If ($_.teamscost -gt 0) {
            $AVNTeamsSpecialsI++
            $AVNTeamsSpecials.add($AVNTeamsSpecialsI, $_.name)
        }
    }
    #need to add the teamscost field. Might need to make these objects with properties instead of a hash table.

    $AVNTeamsPurchaseChoice -eq ""
    Do {
        Do {
            $AVNTeamsSpecials
            Write-Host "You have " $global:AVNPlayerData_CurrentPlayer.gifs "gifs.`nEnter nothing to exit." -foregroundcolor $global:AVNDefaultTextForegroundColor
            $AVNTeamsPurchaseChoice = Read-Host "Enter the item number of the special you would like to purchase"
            
            #If empty, end function.
            If ($AVNTeamsPurchaseChoice -eq "") {
                Return
            }

            #Validating entry
            If (($AVNTeamsPurchaseChoice -notmatch "\d+") -and ($AVNTeamsPurchaseChoice -ne "?")) {
                Write-Host "Something seems to be wrong with your entry. Please make sure to enter only the integer that's next to your choice or a single ?." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Wait-AVNKeyPress
            }
            If ($AVNTeamsPurchaseChoice -notin $AVNTeamsSpecials.keys) {
                Write-Host "Please only enter the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Wait-AVNKeyPress
            }
        } Until ($AVNTeamsPurchaseChoice -in $AVNTeamsSpecials.keys)

        If ($AVNTeamsPurchaseChoice -eq "?") {
            #Showing info for each applicable special.
            $AVNSpecials | ForEach-Object {
                If ($_.teamscost -gt 0) {
                    Write-Host $_.name "`n" $_.description -foregroundcolor $global:AVNDefaultTextForegroundColor
                }
            }
            Wait-AVNKeyPress
        } Else {
            #Making sure the player has enough gifs for the chosen special
            $AVNTeamsPurchaseChoice = [int]$AVNTeamsPurchaseChoice
            $AVNSpecials | ForEach-Object {
                If ($_.name -eq $AVNTeamsSpecials.$AVNTeamsPurchaseChoice) {
                    $AVNTeamsChosenSpecial = $_
                }
            }
            If ($global:AVNPlayerData_CurrentPlayer.gifs -lt $AVNTeamsChosenSpecial.teamscost) {
                Write-Host "`nSorry, you do not have enough GIFs to purchase that item." -foregroundcolor $global:AVNDefaultTextForegroundColor #change to "trade" or "win?" 
            }
        }
    } Until (($global:AVNPlayerData_CurrentPlayer.gifs -ge $AVNTeamsChosenSpecial.teamscost) -and ($AVNTeamsPurchaseChoice -ne "?"))

    #Subtracting from player's GIFs
    $global:AVNPlayerData_CurrentPlayer.gifs -= $AVNTeamsChosenSpecial.teamscost

    #Adding to player's specials
    $global:AVNSpecials_CurrentPlayer += $AVNTeamsChosenSpecial.name
    
    ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile

    Write-Host "You purchased a " $AVNTeamsChosenSpecial.name " for " $AVNTeamsChosenSpecial.teamscost " GIFs.`n" $AVNTeamsChosenSpecial.description -foregroundcolor $global:AVNDefaultTextForegroundColor

    Wait-AVNKeyPress
}
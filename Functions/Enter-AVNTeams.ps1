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

    #Intro Graphic
    $AVNTeamsAnim = Get-Content ($AVNRootPath + "\Media\AVNTeamsAnim")
    $AVNTeamsAnim  | ForEach-Object {
        Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
        Start-Sleep -Milliseconds 20
    }

    #Getting specials
    #Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
    $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
    $AVNDataFileContent | ForEach-Object {
    Invoke-Expression $_
    }
    
    [int]$AVNSpecialsI = 0
    $AVNSpecialsPossibleChoices = @('?')
    $AVNSpecialsTable = @(
        ForEach ($AVNSpecial in $AVNSpecials) {
            If ($AVNSpecial.teamscost -gt 0) {
                $AVNSpecialsI++
                $AVNSpecialsPossibleChoices += $AVNSpecialsI
                $AVNSpecialProperties = [ordered]@{
                    Item = $AVNSpecialsI
                    Name = $AVNSpecial.name
                    Type = $AVNSpecial.type
                    Cost = $AVNSpecial.teamscost
                    Effect = $AVNSpecial.effectdescription
                }
                New-Object psobject -property $AVNSpecialProperties
            }
        }
    )

    Do {
        Do {
            Write-Host "⣿ADVENTURENET⣿Specials⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
            Write-Output $AVNSpecialsTable | Sort-Object "item" | Format-Table item,cost,type,name,effect

            Write-Host "You have" $global:AVNPlayerData_CurrentPlayer.gifs "GIFs." -foregroundcolor $global:AVNDefaultTextForegroundColor
            $AVNTeamsPurchaseChoice = Read-Host "Enter the item number of the special you would like to purchase, ? for more information, or nothing to exit"
            
            #If empty, end function.
            If ($AVNTeamsPurchaseChoice -eq "") {
                Return
            }

            #Validating entry
            If (($AVNTeamsPurchaseChoice -notmatch "\d+") -and ($AVNTeamsPurchaseChoice -ne "?")) {
                Write-Host "`nSomething seems to be wrong with your entry. Please make sure to enter ? or the integer that's next to your choice." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Wait-AVNKeyPress
            } 
            If ($AVNTeamsPurchaseChoice -notin $AVNSpecialsPossibleChoices) {
                Write-Host "`nPlease only enter an ? or the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Wait-AVNKeyPress
            }
        } Until (($AVNTeamsPurchaseChoice -in $AVNSpecialsPossibleChoices) -or ($AVNTeamsPurchaseChoice -eq "?"))

        If ($AVNTeamsPurchaseChoice -eq "?") {
            #Showing info for each applicable special.
            Get-AVNHelp -specials
        } Else {
            #Making sure the player has enough gifs for the chosen special
            $AVNTeamsPurchaseChoice = [int]$AVNTeamsPurchaseChoice
            $AVNSpecialsTable | ForEach-Object {
                If ($AVNTeamsPurchaseChoice -eq $_.item) {
                    $AVNSpecialChoiceDecipheredName = $_.name
                }
            }
            
            $AVNSpecials | ForEach-Object {
                If ($_.name -eq $AVNSpecialChoiceDecipheredName) {
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

    Write-Host "`nYou purchased the following for" $AVNTeamsChosenSpecial.teamscost "GIFs." -foregroundcolor $global:AVNDefaultTextForegroundColor
    
    $AVNTeamsChosenSpecial.name
    $AVNTeamsChosenSpecial.description
    $AVNTeamsChosenSpecial.effectdescription
    Write-Host ""
}
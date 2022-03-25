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
Function Get-AVNGIFs {
    #For selling specials and dice, the idea being that you're trading resources in your frivolous search for entertainment.

    Get-AVNConfig

    $AVNGIFsAnim = Get-Content ($AVNRootPath + "\Media\AVNGIFsAnim")
    $AVNGIFsAnim  | ForEach-Object {
        Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
        Start-Sleep -Milliseconds 20
    }

    #Getting specials. Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
    $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
    $AVNDataFileContent | ForEach-Object {
    Invoke-Expression $_
    }

    $AVNPlayerSpecials = @()
    $global:AVNSpecials_CurrentPlayer | ForEach-Object {
        ForEach ($AVNSTRawSpecial in $AVNSpecials) {
            If (($AVNSTRawSpecial.name -eq $_) -and ($AVNSTRawSpecial.gifreward -gt 0)) {
                $AVNPlayerSpecials += $AVNSTRawSpecial
            }
        }
    }

    [int]$AVNPlayerSpecialsI = 0
    $AVNPlayerSpecialsPossibleChoices = @()
    $AVNPlayerSpecialsTable = @(
        ForEach ($AVNPlayerSpecial in $AVNPlayerSpecials) {
            $AVNPlayerSpecialsI++
            $AVNPlayerSpecialsPossibleChoices += $AVNPlayerSpecialsI
            $AVNPlayerSpecialProperties = [ordered]@{
                Item = $AVNPlayerSpecialsI
                Name = $AVNPlayerSpecial.name
                Type = $AVNPlayerSpecial.type
                Reward = $AVNPlayerSpecial.gifreward
                Effect = $AVNPlayerSpecial.effectdescription
            }
            New-Object psobject -property $AVNPlayerSpecialProperties
        }
    )

    If ($AVNPlayerSpecials.count -lt 1) {
        Write-Host "⣿ADVENTURENET⣿GIFs⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "`nSorry, you don't have any Specials.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Return
    } Else {
        Do {
            Do {
                Write-Host "⣿ADVENTURENET⣿GIFs⣿`n`nTrade unwanted Specials for a GIF reward." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Write-Output $AVNPlayerSpecialsTable | Sort-Object "item" | Format-Table item,name,type,reward,effect
                $AVNPlayerSpecialChoice = Read-Host "Enter the number of the Special you'd like to trade, ? for more information, or nothing to exit"
                
                #If empty, end function.
                If ($AVNPlayerSpecialChoice -eq "") {
                    Return
                }

                #Validating entry
                If (($AVNPlayerSpecialChoice -notmatch "\d+") -and ($AVNPlayerSpecialChoice -ne "?")) {
                    Write-Host "`nSomething seems to be wrong with your entry. Please make sure to enter only an ? or the number that's next to your choice." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Wait-AVNKeyPress
                }
                If (($AVNPlayerSpecialChoice -notin $AVNPlayerSpecialsPossibleChoices) -and ($AVNPlayerSpecialChoice -ne "?")) {
                    Write-Host "`nPlease only enter the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Wait-AVNKeyPress
                }
            } Until (($AVNPlayerSpecialChoice -in $AVNPlayerSpecialsPossibleChoices) -or ($AVNPlayerSpecialChoice -eq "?"))

            If ($AVNPlayerSpecialChoice -eq "?") {
                Get-AVNHelp -specials
            }
        } Until ($AVNPlayerSpecialChoice -ne "?")

        $AVNPlayerSpecialChoice = [int]$AVNPlayerSpecialChoice
        $AVNPlayerSpecialsTable | ForEach-Object {
            If ($AVNPlayerSpecialChoice -eq $_.item) {
                $AVNPlayerSpecialChoiceDecipheredName = $_.name
            }
        }

        $AVNPlayerSpecials | ForEach-Object {
            If ($_.name -eq $AVNPlayerSpecialChoiceDecipheredName) {
                $AVNChosenPlayerSpecial = $_
            }
        }

        Write-Host "`nYou traded your" $AVNChosenPlayerSpecial.name "for a reward of" $AVNChosenPlayerSpecial.gifreward "GIFs." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host ""

        $global:AVNPlayerData_CurrentPlayer.gifs += $AVNChosenPlayerSpecial.gifreward

        #Removing the special from the player's data variable by adding all specials that don't match the chosen variable to a temporary array and then making the normal array mirror the temporary array.
        $AVNPlayerSpecialTempArray = @()
        $AVNSingleEntryLimiter = $False
        $global:AVNSpecials_CurrentPlayer | ForEach-Object {
            If ($_ -eq $AVNChosenPlayerSpecial.name) {
                #Skips the first special matching the variable if there are multiple.
                If ($AVNSingleEntryLimiter -eq $True) {
                    $AVNPlayerSpecialTempArray += $_
                } Else {
                    $AVNSingleEntryLimiter = $True
                }
            } Else {
                $AVNPlayerSpecialTempArray += $_
            }
        }
        $global:AVNSpecials_CurrentPlayer = $AVNPlayerSpecialTempArray

        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
    }
}
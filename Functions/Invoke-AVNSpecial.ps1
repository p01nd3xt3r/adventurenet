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
Function Invoke-AVNSpecial {
    Get-AVNConfig

    #Intro Graphic
    $AVNSpecialAnim = Get-Content ($AVNRootPath + "\Media\AVNSpecialAnim")
    $AVNSpecialAnim  | ForEach-Object {
        Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
        Start-Sleep -Milliseconds 20
    }

    #Getting specials. Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
    $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
    $AVNDataFileContent | ForEach-Object {
    Invoke-Expression $_
    }

    $AVNGeneralSpecials = @()
    $global:AVNSpecials_CurrentPlayer | ForEach-Object {
        ForEach ($AVNSTRawSpecial in $AVNSpecials) {
            If (($AVNSTRawSpecial.name -eq $_) -and ($AVNSTRawSpecial.type -eq 'general')) {
                $AVNGeneralSpecials += $AVNSTRawSpecial
            }
        }
    }
    
    [int]$AVNGeneralSpecialsI = 0
    $AVNGeneralSpecialsPossibleChoices = @()
    $AVNGeneralSpecialsTable = @(
        ForEach ($AVNGeneralSpecial in $AVNGeneralSpecials) {
            $AVNGeneralSpecialsI++
            $AVNGeneralSpecialsPossibleChoices += $AVNGeneralSpecialsI
            $AVNGeneralSpecialProperties = [ordered]@{
                Item = $AVNGeneralSpecialsI
                Name = $AVNGeneralSpecial.name
                Type = $AVNGeneralSpecial.type
                Effect = $AVNGeneralSpecial.effectdescription
            }
            New-Object psobject -property $AVNGeneralSpecialProperties
        }
    )

    If ($AVNGeneralSpecials.count -lt 1) {
        Write-Host "⣿ADVENTURENET⣿Specials⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "`nSorry, you don't have any Specials of General type.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Return
    } Else {
        Do {
            Do {
                #Old $AVNGeneralSpecialsHashTable
                Write-Host "⣿ADVENTURENET⣿Specials⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
                Write-Output $AVNGeneralSpecialsTable | Sort-Object "item" | Format-Table item,name,effect
                $AVNGeneralSpecialChoice = Read-Host "Enter the number of the Special you'd like to use, ? for more information, or nothing to exit"
                
                #If empty, end function.
                If ($AVNGeneralSpecialChoice -eq "") {
                    Return
                }

                #Validating entry
                If (($AVNGeneralSpecialChoice -notmatch "\d+") -and ($AVNGeneralSpecialChoice -ne "?")) {
                    Write-Host "`nSomething seems to be wrong with your entry. Please make sure to enter only an ? or the number that's next to your choice." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Wait-AVNKeyPress
                }
                If (($AVNGeneralSpecialChoice -notin $AVNGeneralSpecialsPossibleChoices) -and ($AVNGeneralSpecialChoice -ne "?")) {
                    Write-Host "`nPlease only enter the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Wait-AVNKeyPress
                }
            } Until (($AVNGeneralSpecialChoice -in $AVNGeneralSpecialsPossibleChoices) -or ($AVNGeneralSpecialChoice -eq "?"))

            If ($AVNGeneralSpecialChoice -eq "?") {
                Get-AVNHelp -specials
            }
        } Until ($AVNGeneralSpecialChoice -ne "?")

        $AVNGeneralSpecialChoice = [int]$AVNGeneralSpecialChoice
        $AVNGeneralSpecialsTable | ForEach-Object {
            If ($AVNGeneralSpecialChoice -eq $_.item) {
                $AVNGeneralSpecialChoiceDecipheredName = $_.name
            }
        }

        $AVNGeneralSpecials | ForEach-Object {
            If ($_.name -eq $AVNGeneralSpecialChoiceDecipheredName) {
                $AVNChosenGeneralSpecial = $_
            }
        }

        Write-Host "`nYou used your" $AVNChosenGeneralSpecial.name -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNChosenGeneralSpecial.description
        $AVNChosenGeneralSpecial.effectdescription
        Write-Host ""

        Invoke-Expression $AVNChosenGeneralSpecial.effect
        $global:AVNPlayerData_CurrentPlayer.globalnotice = $AVNChosenGeneralSpecial.globalnotice

        #Removing the special from the player's data variable by adding all specials that don't match the chosen variable to a temporary array and then making the normal array mirror the temporary array.
        $AVNGeneralSpecialTempArray = @()
        $AVNSingleEntryLimiter = $False
        $global:AVNSpecials_CurrentPlayer | ForEach-Object {
            If ($_ -eq $AVNChosenGeneralSpecial.name) {
                #Skips the first special matching the variable if there are multiple.
                If ($AVNSingleEntryLimiter -eq $True) {
                    $AVNGeneralSpecialTempArray += $_
                } Else {
                    $AVNSingleEntryLimiter = $True
                }
            } Else {
                $AVNGeneralSpecialTempArray += $_
            }
        }
        $global:AVNSpecials_CurrentPlayer = $AVNGeneralSpecialTempArray
    }
    
    ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
}

    
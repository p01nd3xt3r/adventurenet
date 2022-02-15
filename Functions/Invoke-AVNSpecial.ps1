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

    Write-Host "`n    ███████ ██████  ███████  ██████ ██  █████  ██      ███████    `n    ██      ██   ██ ██      ██      ██ ██   ██ ██      ██         `n    ███████ ██████  █████   ██      ██ ███████ ██      ███████    `n         ██ ██      ██      ██      ██ ██   ██ ██           ██    `n    ███████ ██      ███████  ██████ ██ ██   ██ ███████ ███████    `n`n" -foregroundcolor $global:AVNDefaultBannerForegroundColor

    #Getting specials. Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
    $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
    $AVNDataFileContent | ForEach-Object {
    Invoke-Expression $_
    }
    <#
    Old
    (Get-Content -path ($global:AVNRootPath + "\XQxoHZJajcgW")) | ForEach-Object {
        Invoke-Expression $_
    }
    #>

    $AVNGeneralSpecials = @()
    $global:AVNSpecials_CurrentPlayer | ForEach-Object {
        ForEach ($AVNSTRawSpecial in $AVNSpecials) {
            If (($AVNSTRawSpecial.name -eq $_) -and ($AVNSTRawSpecial.type -eq 'general')) {
                $AVNGeneralSpecials += $AVNSTRawSpecial
            }
        }
    }
    
    $AVNGeneralSpecialsHashTable = @{
        '?' = 'Show information about your options.'
    }
    [int]$AVNGeneralSpecialsHashTableI = 0
    $AVNGeneralSpecials | ForEach-Object {
        $AVNGeneralSpecialsHashTableI++
        $AVNGeneralSpecialsHashTable.add($AVNGeneralSpecialsHashTableI, $_.name)
    }

    If ($AVNGeneralSpecials.count -lt 1) {
        Write-Host "Sorry, you don't have any general specials." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Return
    } Else {
        Do {
            Do {
                Write-Host "What would you like to do?" -foregroundcolor $global:AVNDefaultTextForegroundColor
                $AVNGeneralSpecialsHashTable
                $AVNGeneralSpecialChoice = Read-Host "Please enter the number next to the special you'd like to use"
                
                #Validating entry
                If (($AVNGeneralSpecialChoice -notmatch "\d+") -and ($AVNGeneralSpecialChoice -ne "?")) {
                    Write-Host "Something seems to be wrong with your entry. Please make sure to enter only the integer that's next to your choice or a single ?." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Wait-AVNKeyPress
                }
                If ($AVNGeneralSpecialChoice -notin $AVNGeneralSpecialsHashTable.keys) {
                    Write-Host "Please only enter the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Wait-AVNKeyPress
                }
            } Until ($AVNGeneralSpecialChoice -in $AVNGeneralSpecialsHashTable.keys)

            If ($AVNTeamsPurchaseChoice -eq "?") {
                #Showing info for each general special.
                $AVNGeneralSpecials | ForEach-Object {
                    Write-Host $_.name "`n" $_.description -foregroundcolor $global:AVNDefaultTextForegroundColor
                }
                Wait-AVNKeyPress
            }
        }Until ($AVNTeamsPurchaseChoice -ne "?")

        $AVNGeneralSpecialChoice = [int]$AVNGeneralSpecialChoice

        $AVNGeneralSpecials | ForEach-Object {
            If ($_.name -eq $AVNGeneralSpecialsHashTable.$AVNGeneralSpecialChoice) {
                $AVNChosenGeneralSpecial = $_
            }
        }

        Write-Host "`nYou used your" $AVNChosenGeneralSpecial.name "`n" $AVNChosenGeneralSpecial.description -foregroundcolor $global:AVNDefaultTextForegroundColor
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

    
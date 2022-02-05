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
Function Get-AVNTraining {
    If ($global:AVNPlayerData_CurrentPlayer.training -gt 0) {
        Write-Host "                                                                                                         `n                        ████████ ██████   █████  ██ ███    ██ ██ ███    ██  ██████                       `n                           ██    ██   ██ ██   ██ ██ ████   ██ ██ ████   ██ ██                            `n                           ██    ██████  ███████ ██ ██ ██  ██ ██ ██ ██  ██ ██   ███                      `n                           ██    ██   ██ ██   ██ ██ ██  ██ ██ ██ ██  ██ ██ ██    ██                      `n                           ██    ██   ██ ██   ██ ██ ██   ████ ██ ██   ████  ██████                       `n                                                                                                         `n                                                                                                         `n`n" -BackgroundColor $global:AVNDefaultBannerBackgroundColor -ForegroundColor $global:AVNDefaultBannerForegroundColor
        
        
        If ($global:AVNCompanyDataCommon -lt 15) {
            If ($global:AVNPlayerData_CurrentPlayer.gifs -lt 10) {
                Write-Host "Note that as a result of low team health, training requires 10 GIFs, and you don't have enough." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            } Else {
                Do {
                    Write-Host "Note that as a result of low team health, training requires 10 GIFs. Your GIFs:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $global:AVNPlayerData_CurrentPlayer.gifs
                    
                    $AVNTrainingConfirmation = "n"
                    $AVNTrainingGIFConfirmation = Read-Host "Would you like to proceed? (y/n)"
                    If (($AVNTrainingGIFConfirmation -ne "y") -and ($AVNTrainingGIFConfirmation -ne "yes") -and ($AVNTrainingGIFConfirmation -ne 'n') -and ($AVNTrainingGIFConfirmation -ne 'no')) {
                        Write-Host "You've entered something odd. Please only enter y or n." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    }
                } Until (($AVNTrainingGIFConfirmation -eq "y") -or ($AVNTrainingGIFConfirmation -eq "yes") -or ($AVNTrainingGIFConfirmation -eq 'n') -or ($AVNTrainingGIFConfirmation -eq 'no'))
                If (($AVNTrainingGIFConfirmation -eq 'n') -or ($AVNTrainingGIFConfirmation -eq 'no')) {
                    Return
                }
            }
        }
        
        #Getting dice info table.
        (Get-Content -path ($global:AVNRootPath + "\bGBIuKWniXYw")) | ForEach-Object {
            Invoke-Expression $_
        }

        $AVNTrainingDiceTypes = [ordered]@{
            '?' = 'Show information about your options.'
            1 = "Microsoft365"
            2 = "Datto"
            3 = "MimecastUmbrella"
            4 = "Windows"
            5 = "HuntressDefender"
            6 = "CoreValues"
            7 = "ITGlue"
        }
        
        If ($global:AVNCompanyDataCommon.teamhealth -ge 0) {
            Write-Host "Choose any one dice to permanently add to your collection." -foregroundcolor $global:AVNDefaultTextForegroundColor
            Do {
                Do {
                    $AVNTrainingDiceTypes
                    $AVNTrainingChoice = Read-Host "Please enter the number of the die you'd like to keep (enter nothing to exit)"
                    
                    #If empty, end function.
                    If ($AVNTrainingChoice -eq "") {
                        Return
                    }
                    #Validating entry
                    If (($AVNTrainingChoice -notmatch "\d+") -and ($AVNTrainingChoice -ne "?")) {
                        Write-Host "Something seems to be wrong with your entry. Please make sure to enter only the integer that's next to your choice or a single ?." -foregroundcolor $global:AVNDefaultTextForegroundColor
                        Wait-AVNKeyPress
                    }
                    If ($AVNTrainingChoice -notin $AVNTrainingDiceTypes.keys) {
                        Write-Host "Please only enter ? or the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                        Wait-AVNKeyPress
                    }
                } Until ($AVNTrainingChoice -in $AVNTrainingDiceTypes.keys)
                #Showing info about the dice.
                If ($AVNTrainingChoice -eq "?") {
                    Get-AVNHelp -dice
                }
            } Until ($AVNTrainingChoice -ne "?")

            $AVNTrainingChoice = [int]$AVNTrainingChoice
            $global:AVNDicePerm_CurrentPlayer += $AVNTrainingDiceTypes.$AVNTrainingChoice

            Write-Host "`nCongratulations! You've attained the following permanent die." -foregroundcolor $global:AVNDefaultTextForegroundColor
            $AVNTrainingDiceTypes.$AVNTrainingChoice
            If ($global:AVNCompanyDataCommon -lt 15) {
                $global:AVNPlayerData_CurrentPlayer.gifs -= 10
            }
            $global:AVNPlayerData_CurrentPlayer.training -= 1
        } Else {
            Do {
                Do {
                    Write-Host "`nWelcome to training. As a result of low team health, in addition to requiring 10 GIFs, your die will be randomly assigned to you." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNTrainingConfirmation = "n"
                    $AVNTrainingConfirmation = Read-Host "Would you like to proceed? (y/n/?)"
                    If (($AVNTrainingConfirmation -ne "y") -and ($AVNTrainingConfirmation -ne "yes") -and ($AVNTrainingConfirmation -ne 'n') -and ($AVNTrainingConfirmation -ne 'no') -and ($AVNTrainingConfirmation -ne "?")) {
                        Write-Host "You've entered something odd. Please only enter y or n." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    }
                    If ($AVNTrainingChoice -eq "?") {
                        Get-AVNHelp -dice
                    }
                } Until ($AVNTrainingChoice -ne "?")
            } Until (($AVNTrainingConfirmation -eq "y") -or ($AVNTrainingConfirmation -eq "yes") -or ($AVNTrainingConfirmation -eq 'n') -or ($AVNTrainingConfirmation -eq 'no'))
            If (($AVNTrainingConfirmation -eq "y") -or ($AVNTrainingConfirmation -eq "yes")) {
                $AVNTrainingRoll = Get-Random -minimum 1 -maximum 7
                $global:AVNDicePerm_CurrentPlayer += $AVNTrainingDiceTypes.$AVNTrainingRoll

                $global:AVNPlayerData_CurrentPlayer.gifs -= 10
                $global:AVNPlayerData_CurrentPlayer.training -= 1

                Write-Host "`nYou have aquired the following permanent die:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                $AVNTrainingDiceTypes.$AVNTrainingRoll
                
                Wait-AVNKeypress
            } Else {
                Return
            }
        }
    } Else {
        Write-Host "Sorry, you don't have any training available." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Wait-AVNKeyPress
        Return
    }
    ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
}
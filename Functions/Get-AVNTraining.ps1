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
    #Intro Graphic
    $AVNTrainingAnim = Get-Content ($AVNRootPath + "\Media\AVNTrainingAnim")
    $AVNTrainingAnim  | ForEach-Object {
        Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
        Start-Sleep -Milliseconds 20
    }
    
    Write-Host "⣿ADVENTURENET⣿Training⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor

    If ($global:AVNPlayerData_CurrentPlayer.training -gt 0) {
        If ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -ge 2) {
            If ($global:AVNPlayerData_CurrentPlayer.gifs -lt 10) {
                Write-Host "`nNote that as a result of low team health, training requires 10 GIFs, and you don't have enough." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            } Else {
                Do {
                    Write-Host "`nNote that as a result of low team health, training requires 10 GIFs. Your GIFs:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $global:AVNPlayerData_CurrentPlayer.gifs
                    
                    $AVNTrainingConfirmation = "n"
                    $AVNTrainingGIFConfirmation = Read-Host "`nWould you like to proceed? (y/n)"
                    If (($AVNTrainingGIFConfirmation -ne "y") -and ($AVNTrainingGIFConfirmation -ne "yes") -and ($AVNTrainingGIFConfirmation -ne 'n') -and ($AVNTrainingGIFConfirmation -ne 'no')) {
                        Write-Host "`nYou've entered something odd. Please only enter y or n." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    }
                } Until (($AVNTrainingGIFConfirmation -eq "y") -or ($AVNTrainingGIFConfirmation -eq "yes") -or ($AVNTrainingGIFConfirmation -eq 'n') -or ($AVNTrainingGIFConfirmation -eq 'no'))
                If (($AVNTrainingGIFConfirmation -eq 'n') -or ($AVNTrainingGIFConfirmation -eq 'no')) {
                    Return
                }
            }
        }
        
        #Getting dice info table.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\bGBIuKWniXYw")
        $AVNDataFileContent | ForEach-Object {
        Invoke-Expression $_
        }

        $AVNTrainingDiceTypes = [ordered]@{
            '?' = 'Show information about your options.'
            1 = "CoreValues"
            2 = "Datto"
            3 = "HuntressDefender"
            4 = "ITGlue"
            5 = "Microsoft365"
            6 = "MimecastUmbrella"
            7 = "Ubiquiti"
            8 = "Windows"
        }
        
        If ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -lt 5) {
           Do {
                Do {
                    Write-Host "`nChoose any one dice to permanently add to your collection." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNTrainingDiceTypes
                    $AVNTrainingChoice = Read-Host "`nPlease enter the number of the die you'd like to keep (enter nothing to exit)"
                    
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
            If ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -ge 2) {
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
                $AVNTrainingRoll = Get-Random -minimum 1 -maximum 8
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
        Write-Host "`nSorry, you don't have any training available.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Return
    }
    ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
}
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
    Get-AVNConfig
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
        
        #Getting dice info table. Yields $AVNDiceValues variable.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\bGBIuKWniXYw")
        $AVNDataFileContent | ForEach-Object {
        Invoke-Expression $_
        }

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
        Write-Host "`nYou have the following dice:" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNDiceTable | Sort-Object dice,type | Format-Table Dice,Type
        
        $AVNTrainingDiceTypesTableI = 0
        $AVNTrainingDiceTypesTable = @(
            $AVNDiceValues.keys | Sort-Object | ForEach-Object {
                $AVNTrainingDiceTypesTableI++
                $AVNTrainingDiceTypesProperties = [ordered]@{
                    Item = $AVNTrainingDiceTypesTableI
                    Dice = $_
                }
                New-Object psobject -property $AVNTrainingDiceTypesProperties
            }
        )
        
        If ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -lt 5) {
           Do {
                Do {
                    Write-Host "`nChoose any one dice to permanently add to your collection." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Write-Output $AVNTrainingDiceTypesTable | Sort-Object item | Format-Table Item,Dice
                    $AVNTrainingChoice = Read-Host "`nPlease enter the item number of the die you'd like to keep or ? for more information (enter nothing to exit)"
                    
                    #If empty, end function.
                    If ($AVNTrainingChoice -eq "") {
                        Write-Host ""
                        Return
                    }
                    #Validating entry
                    If (($AVNTrainingChoice -notmatch "\d+") -and ($AVNTrainingChoice -ne "?")) {
                        Write-Host "`nSomething seems to be wrong with your entry. Please make sure to enter only the integer that's next to your choice or a single ?." -foregroundcolor $global:AVNDefaultTextForegroundColor
                        Wait-AVNKeyPress
                    } ElseIf (($AVNTrainingChoice -notin ($AVNTrainingDiceTypesTable | ForEach-Object {$_.Item})) -and ($AVNTrainingChoice -ne "?")) {
                        Write-Host "`nPlease only enter ? or the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                        Wait-AVNKeyPress
                    }
                } Until (($AVNTrainingChoice -in ($AVNTrainingDiceTypesTable | ForEach-Object {$_.Item})) -or ($AVNTrainingChoice -eq "?"))
                #Showing info about the dice.
                If ($AVNTrainingChoice -eq "?") {
                    Get-AVNHelp -dice
                }
            } Until ($AVNTrainingChoice -ne "?")

            $AVNTrainingChoice = [int]$AVNTrainingChoice
            $global:AVNDicePerm_CurrentPlayer += ($AVNTrainingDiceTypesTable | Where-Object {$AVNTrainingChoice -eq $_.item}).dice

            Write-Host "`nCongratulations! You've attained the following permanent die." -foregroundcolor $global:AVNDefaultTextForegroundColor
            ($AVNTrainingDiceTypesTable | Where-Object {$AVNTrainingChoice -eq $_.item}).dice
            Write-Host ""
            
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
                        Write-Host "`nYou've entered something odd. Please only enter y or n." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    }
                    If ($AVNTrainingChoice -eq "?") {
                        Get-AVNHelp -dice
                    }
                } Until ($AVNTrainingChoice -ne "?")
            } Until (($AVNTrainingConfirmation -eq "y") -or ($AVNTrainingConfirmation -eq "yes") -or ($AVNTrainingConfirmation -eq 'n') -or ($AVNTrainingConfirmation -eq 'no'))
            If (($AVNTrainingConfirmation -eq "y") -or ($AVNTrainingConfirmation -eq "yes")) {
                $AVNTrainingRoll = Get-Random -minimum 1 -maximum 8
                $global:AVNDicePerm_CurrentPlayer += ($AVNTrainingDiceTypesTable | Where-Object {$AVNTrainingRoll -eq $_.item}).dice

                $global:AVNPlayerData_CurrentPlayer.gifs -= 10
                $global:AVNPlayerData_CurrentPlayer.training -= 1

                Write-Host "`nYou have aquired the following permanent die:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                ($AVNTrainingDiceTypesTable | Where-Object {$AVNTrainingRoll -eq $_.item}).dice
                Write-Host ""
                
                Wait-AVNKeypress
            } Else {
                Write-Host ""
                Return
            }
        }
    } Else {
        Write-Host "`nSorry, you don't have any training available.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Return
    }
    ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
}
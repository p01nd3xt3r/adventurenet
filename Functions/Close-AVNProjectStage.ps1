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
Function Close-AVNProjectStage {
    #Same as service tickets but harder. Assumes the player has trained numerous times and horded some specials. Each player faces the same, designed bloc of waves. The project stage counter attacks after a player successfully defeats a wave. Players may attempt stages repeatedly, according to the configured alottment of allowed attempts per day.
    
    Get-AVNConfig

    #Getting project stage Bloc data
    #Yields the $AVNProjectStage1Bloc and $AVNProjectStage2Bloc and $AVNProjectStage3Bloc arrays of hashtables.
    (Get-Content -path ($global:AVNRootPath + "\wlBjUrtSsTIO")) | ForEach-Object {
        Invoke-Expression $_
    }

    #Getting specials
    #Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
    $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
    $AVNDataFileContent | ForEach-Object {
    Invoke-Expression $_
    }

    #Intro text and assigning correct stage to current
    If ($global:AVNPlayerData_CurrentPlayer.ProjectStageAttempts -ge $global:AVNProjectStageDailyAllowance) {
        Write-Host "`nYou have already attempted Project Stages the maximum number of times for your current Invoke-AVNSignOn.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Return
    } Else {
        #Writing data so that if the player tries to use ctrl+c to get out of it, he's already lost whatever it is.
        $global:AVNPlayerData_CurrentPlayer.ProjectStageAttempts += 1
        $global:AVNCompanyData_CurrentPlayer.teamhealth -= 1
        $global:AVNCompanyData_CurrentPlayer.clienthealth -= 2
        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
        Get-AVNConfig

        If ($global:AVNCompanyDataCommon.ProjectStage1BlocsRemaining -gt 0) {
            If ($global:AVNCompanyData_CurrentPlayer.ProjectStage1BlocDefeated -gt 0) {
                Write-Host "`nYou have already closed your Project Stage 1 bloc.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            } Else {
                [int]$AVNProjectCurrentStage = 1
                $AVNProjectCurrentStageArray = $AVNProjectStage1Bloc
                #Intro Graphic
                $AVNStage1Anim = Get-Content ($AVNRootPath + "\Media\AVNStage1Anim")
                $AVNStage1Anim  | ForEach-Object {
                    Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
                    Start-Sleep -Milliseconds 20
                }
            } 
        } ElseIf ($global:AVNCompanyDataCommon.ProjectStage2BlocsRemaining -gt 0) {
            If ($global:AVNCompanyData_CurrentPlayer.ProjectStage2BlocDefeated -gt 0) {
                Write-Host "`nYou have already closed your Project Stage 2 bloc.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            } Else {
                [int]$AVNProjectCurrentStage = 2
                $AVNProjectCurrentStageArray = $AVNProjectStage2Bloc
                #Intro Graphic
                $AVNStage2Anim = Get-Content ($AVNRootPath + "\Media\AVNStage2Anim")
                $AVNStage2Anim  | ForEach-Object {
                    Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
                    Start-Sleep -Milliseconds 20
                }
            }
        } ElseIf ($global:AVNCompanyDataCommon.ProjectStage3BlocsRemaining -gt 0) {
            If ($global:AVNCompanyData_CurrentPlayer.ProjectStage3BlocDefeated -gt 0) {
                Write-Host "`nYou have already closed your Project Stage 3 bloc.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            } Else {
                [int]$AVNProjectCurrentStage = 3
                $AVNProjectCurrentStageArray = $AVNProjectStage3Bloc
                #Intro Graphic
                $AVNStage3Anim = Get-Content ($AVNRootPath + "\Media\AVNStage3Anim")
                $AVNStage3Anim  | ForEach-Object {
                    Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
                    Start-Sleep -Milliseconds 20
                }
            }
        } Else {
            #Complete graphic
            $AVNStagesCompleteAnim = Get-Content ($AVNRootPath + "\Media\AVNStagesCompleteAnim")
                $AVNStagesCompleteAnim  | ForEach-Object {
                    Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
                    Start-Sleep -Milliseconds 20
                }
            
            Write-Host "After all remaining turns have been used, this season of AdventureNet will have been completed." -foregroundcolor $global:AVNDefaultTextForegroundColor
            Wait-AVNKeyPress
            Return
        }
    }

    #Getting dice info table.
    $AVNDiceDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\bGBIuKWniXYw")
    $AVNDiceDataFileContent | ForEach-Object {
        Invoke-Expression $_
    }

    #Gathering resources as functions, so I can call them more easily later on.
    Function GatherAvailablePreEmptiveSpecials {
        #Cycling through the player's specials and creating a full version of it in a temporary variable to be used in this function.
        #If this goes in the function, I just have to remove the special from the global variable and then run the function to get the current ones again.
        $AVNPreEmptiveSpecials = @()
        $global:AVNSpecials_CurrentPlayer | ForEach-Object {
            ForEach ($AVNRawSpecial in $AVNSpecials) {
                If (($AVNRawSpecial.name -eq $_) -and ($AVNRawSpecial.type -eq 'preemptive')) {
                    $AVNPreEmptiveSpecials += $AVNRawSpecial
                }
            }
        }
        $AVNPreEmptiveSpecials = $AVNPreEmptiveSpecials | Sort-Object
        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
        Get-AVNConfig
        Return $AVNPreEmptiveSpecials
    }

    Function GatherAvailableInterruptSpecials {
        #Cycling through the player's specials and creating a full version of it in a temporary variable to be used in this function.
        #If this goes in the function, I just have to remove the special from the global variable and then run the function to get the current ones again.
        $AVNInterruptSpecials = @()
        $global:AVNSpecials_CurrentPlayer | ForEach-Object {
            ForEach ($AVNRawSpecial in $AVNSpecials) {
                If (($AVNRawSpecial.name -eq $_) -and ($AVNRawSpecial.type -eq 'interrupt')) {
                    $AVNInterruptSpecials += $AVNRawSpecial
                }
            }
        }
        $AVNInterruptSpecials = $AVNInterruptSpecials | Sort-Object
        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
        Get-AVNConfig
        Return $AVNInterruptSpecials
    }

    Function GatherAvailableInjectionSpecials {
        $AVNInjectionSpecials = @()
        $global:AVNSpecials_CurrentPlayer | ForEach-Object {
            ForEach ($AVNRawSpecial in $AVNSpecials) {
                If (($AVNRawSpecial.name -eq $_) -and ($AVNRawSpecial.type -eq 'injection')) {
                    $AVNInjectionSpecials += $AVNRawSpecial
                }
            }
        }
        $AVNInjectionSpecials = $AVNInjectionSpecials | Sort-Object
        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
        Get-AVNConfig
        Return $AVNInjectionSpecials
    }

    $AVNSpecialDice = @()
    Function GatherAvailableDice {
        $AVNAvailableDice = [ordered]@{}
        [int]$AvailableDiceI = 0
        $AVNAllDice = @()
        $AVNAllDice += $global:AVNDicePerm_CurrentPlayer
        $AVNAllDice += $global:AVNDiceDaily_CurrentPlayer
        $AVNAllDice += $AVNSpecialDice
        $AVNAllDice = $AVNAllDice | Sort-Object
        $AVNAllDice | ForEach-Object {
            $AvailableDiceI++
            $AVNAvailableDice.add($AvailableDiceI, $_)
        }
        <#
        Before alphebetizing
        $global:AVNDicePerm_CurrentPlayer | ForEach-Object {
            $AvailableDiceI++
            $AVNAvailableDice.add($AvailableDiceI, $_)
        }
        $global:AVNDiceDaily_CurrentPlayer | ForEach-Object {
            $AvailableDiceI++
            $AVNAvailableDice.add($AvailableDiceI, $_)
        }
        If ($AVNSpecialDice.count -gt 0) {
            $AVNSpecialDice | ForEach-Object {
                $AvailableDiceI++
                $AVNAvailableDice.add($AvailableDiceI, $_)
            }
        }
        #>
        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
        Get-AVNConfig
        Return $AVNAvailableDice
    }

    #Doing this here instead of the loop because it should only be used at the beginning, unless a special runs it again. When they are used, I will remove them from these variables, and for specials, I remove them from the master variable as well.
    $AVNAvailableDice = GatherAvailableDice
    $AVNInterruptSpecials = GatherAvailableInterruptSpecials
    $AVNPreEmptiveSpecials = GatherAvailablePreEmptiveSpecials
    $AVNInjectionSpecials = GatherAvailableInjectionSpecials
    




    $AVNProjectCurrentWave = 1
    $AVNProjectAllWavesComplete = $False
    Do {
        #Cycles waves until all waves complete. Includes rolls. If the player's roll succeeds for a wave, increase the wave integer, invoke the wave's counterattack, and circle back through this loop with the appropriate wave criteria.
        Do {
            #Cycles choice entries until the player rolls. Includes info and pre-emptive special use.
            Do {
                #Cycles entries until the player's entry is valid

                #Gathering the current wave's info.
                $Iteration = 0
                $AVNProjectCurrentStageArray | ForEach-Object {
                    If ($_.wave -eq $AVNProjectCurrentWave) {
                        $AVNProjectCurrentStageCurrentWaveHashTable = $_
                    }
                }

                #Informing/prepping the player
                Write-Host "The project looms before you--three stages with three waves apiece. You are on Stage" $AVNProjectCurrentStage "`b, Wave" $AVNProjectCurrentWave "." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Write-Host "`n⣿ADVENTURENET⣿Project⣿`n`nYou see the following defenses for this wave:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                $AVNProjectCurrentStageCurrentWaveHashTable.defenses

                #Default choices.
                [int]$AVNOptionI = 0
                $AVNProjectCurrentWaveOptions = [ordered]@{
                    '?' = 'Show information about your options.'
                    'R' = 'Run away!'
                }
                If ($AVNAvailableDice.count -gt 0) {
                    $AVNOptionI++
                    $AVNProjectCurrentWaveOptions.add($AVNOptionI, 'Attack!')
                } Else {
                    Write-Host "`nYou have no dice with which to attack!" -foregroundcolor $global:AVNDefaultTextForegroundColor
                }
                #Adding specials to the choices. Changes based on what wave we're on. Also adds all the ints of these specials to $AVNSpecialIntegers, so I can know a special has been chosen later. I might not need, this, though, if I only do ?, attack, and specials. I'd always know the range, and the ints of those options would be constant.
                If ($AVNProjectCurrentWave -eq 1) {
                    $AVNSpecialIntegers = @()
                    If ($AVNPreEmptiveSpecials.count -gt 0) {
                        $AVNPreEmptiveSpecials | ForEach-Object {
                            $AVNOptionI++
                            $AVNSpecialIntegers += $AVNOptionI
                            $AVNProjectCurrentWaveOptions.add($AVNOptionI, $_.name)
                        }
                    }
                } Else {
                    $AVNSpecialIntegers = @()
                    If ($AVNInterruptSpecials.count -gt 0) {
                        $AVNInterruptSpecials | ForEach-Object {
                            $AVNOptionI++
                            $AVNSpecialIntegers += $AVNOptionI
                            $AVNProjectCurrentWaveOptions.add($AVNOptionI, $_.name)
                        }
                    }
                }

                Write-Host "`nYou have the following options:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                $AVNProjectCurrentWaveOptions
                $AVNProjectCurrentWaveChoice = Read-Host "Enter your choice"

                #Validating entry
                If (($AVNProjectCurrentWaveChoice -notmatch "\d+") -and ($AVNProjectCurrentWaveChoice -ne "?") -and ($AVNProjectCurrentWaveChoice -ne "r")) {
                    Write-Host "`nSomething seems to be wrong with your entry. Please make sure to enter only the integer that's next to your choice or a single ?." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Wait-AVNKeyPress
                } ElseIf ($AVNProjectCurrentWaveChoice -notin $AVNProjectCurrentWaveOptions.keys) {
                    Write-Host "`nPlease only enter ? or the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Wait-AVNKeyPress
                }
            } Until ($AVNProjectCurrentWaveChoice -in $AVNProjectCurrentWaveOptions.keys)

            If ($AVNProjectCurrentWaveChoice -eq "r") {
                Write-Host "`nYou ran away, and the Project Stage chuckled." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }

            #Now go through results of the player's choice, not including dice.
            If ($AVNProjectCurrentWaveChoice -eq "?") {
                Get-AVNHelp -dice
            } Else {
                #Identifying special, using it, and removing it from the player's global variable.
                $AVNProjectCurrentWaveChoice = [int]$AVNProjectCurrentWaveChoice
                If ($AVNProjectCurrentWaveChoice -gt 1) {
                    If ($AVNProjectCurrentWave -eq 1) {
                        $AVNPreEmptiveSpecials | ForEach-Object {
                            If ($_.name -eq $AVNProjectCurrentWaveOptions.$AVNProjectCurrentWaveChoice) {
                                $AVNProjectCurrentWaveChosenSpecial = $_
                            }
                        }
                    } Else {
                        $AVNInterruptSpecials | ForEach-Object {
                            If ($_.name -eq $AVNProjectCurrentWaveOptions.$AVNProjectCurrentWaveChoice) {
                                $AVNProjectCurrentWaveChosenSpecial = $_
                            }
                        }
                    }   
                    
                    Write-Host "`nYou used your" $AVNProjectCurrentWaveChosenSpecial.name -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNProjectCurrentWaveChosenSpecial.description
                    $AVNProjectCurrentWaveChosenSpecial.effectdescription
                    Invoke-Expression $AVNProjectCurrentWaveChosenSpecial.effect

                    $AVNPlayerDataSpecialsTempArray = @()
                    $AVNProjectSpecialSingleEntryLimiter = $False
                    $global:AVNSpecials_CurrentPlayer | ForEach-Object {
                        If ($_ -eq $AVNProjectCurrentWaveChosenSpecial.name) {
                            #Skips the first special matching the variable if there are multiple.
                            If ($AVNProjectSpecialSingleEntryLimiter -eq $True) {
                                $AVNPlayerDataSpecialsTempArray += $_
                            } Else {
                                $AVNProjectSpecialSingleEntryLimiter = $True
                            }
                        } Else {
                            $AVNPlayerDataSpecialsTempArray += $_
                        }
                    }
                    $global:AVNSpecials_CurrentPlayer = $AVNPlayerDataSpecialsTempArray
                    #End with getting all specials again, which will remove the specials item from the pre-emptive specials array.
                    If ($AVNProjectCurrentWave -eq 1) {
                        $AVNPreEmptiveSpecials = GatherAvailablePreEmptiveSpecials
                    } Else {
                        $AVNInterruptSpecials = GatherAvailableInterruptSpecials
                    }
                    Wait-AVNKeypress
                }
            }
        } Until ($AVNProjectCurrentWaveOptions.$AVNProjectCurrentWaveChoice -eq "Attack!")

        #Presenting player with dice to roll, accepting and then validating their choices.
        Do {
            $AVNDiceRollChoicePass = $True

            Write-Host "`nDefenses for this wave are:" -foregroundcolor $global:AVNDefaultTextForegroundColor
            $AVNProjectCurrentStageCurrentWaveHashTable.defenses
            Write-Host "And you have the following dice available to roll:" -ForegroundColor $global:AVNDefaultTextForegroundColor
            $AVNAvailableDice
            #Create entry hash that includes ?

            [string]$AVNDiceRollChoice = Read-Host "Choose which die or dice you'd like to roll by its number in the above table; for multiple, separate numbers by a comma (ex: 1,2); enter ? to display work-type value alottment per dice; enter nothing to roll all"

            If ($AVNDiceRollChoice -eq '?') {
                Get-AVNHelp -dice
                $AVNDiceRollChoicePass = $False
            }  ElseIf ($AVNDiceRollChoice -eq '') {
                $AVNDiceRollChoiceArray = @()
                For ($I = 1; $I -le $AVNAvailableDice.count; $I++) {
                    $AVNDiceRollChoiceArray += [string]$I
                }
                $AVNDiceRollChoicePass = $True
            } Else {
                $AVNDiceRollChoiceArray = $AVNDiceRollChoice -split ","
                $AVNDiceRollChoiceArrayComparer = $AVNDiceRollChoiceArray | Select-Object -unique
                If ($AVNDiceRollChoiceArray.count -ne $AVNDiceRollChoiceArrayComparer.count) {
                    Write-Host "`nYou appear to have entered the same value more than once. You can only roll any dice once without an appropriate special." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNDiceRollChoicePass = $False
                    #A special might change this.
                    Wait-AVNKeyPress
                }
                $AVNDiceRollChoiceArray | ForEach-Object {
                    If ($_ -notmatch "\d+") {
                        $AVNDiceRollChoicePass = $False
                        Write-Host "`nSomething is odd about your entry. Please make sure to enter using the appropriate format. No letters or special characters are permitted, and if you're trying to get information about the dice, please enter a solitary ?." -foregroundcolor $global:AVNDefaultTextForegroundColor
                        Wait-AVNKeyPress
                    } ElseIf ([int]$_ -notin $AVNAvailableDice.keys){
                        $AVNDiceRollChoicePass = $False
                        Write-Host "`nPlease only enter a number that's in your list of available dice." -foregroundcolor $global:AVNDefaultTextForegroundColor
                        Wait-AVNKeyPress
                    }
                }
            }
        } Until ($AVNDiceRollChoicePass -eq $True)

        #Gathering dice, evaluating worktypes per dice, weighting and randomizing their rolls. Ends with the $AVNDiceRolls array variable, which just has the worktypes that are rolled by all chosen dice.
        $AVNDiceRolls = @()
        $AVNDiceRollChoiceArray | ForEach-Object {
            #Converting the current int that the person entered into the worktype that it represents.
            $AVNProjectRollChoiceType = $AVNAvailableDice.([int]$_)
            $AVNDiceRollChoiceTypeHashTable = $AVNDiceValues.$AVNProjectRollChoiceType
            #Removing it from the available dice by the int that the player entered.
            $AVNAvailableDice.remove([int]$_)
            $AVNDiceRollChoiceTypeWeightArray = @()
            #Goes through each dice type's values and adds an array entry for each side of the die, so to speak, to properly weight a random roll. Dice with multiple sides that have the same value should end up with multiple of that value in the array, and then get-random chooses from all of them--even the multiples. This basically just adds an entry to the $AVNDiceRollChoiceTypeWeightArray array for each int in $AVNDiceRollChoiceTypeHashTable.
            $AVNDiceRollChoiceTypeHashTable.keys | ForEach-Object {
                For ($AVNDiceRollChoiceTypeHashTableValueI = 0; $AVNDiceRollChoiceTypeHashTableValueI -lt $AVNDiceRollChoiceTypeHashTable.$_; $AVNDiceRollChoiceTypeHashTableValueI++) {
                    $AVNDiceRollChoiceTypeWeightArray += $_
                }
            }
            #This should be an array of all rolls that are chosen. It'll be a string of the work type rolled by that dice, weighted by the numbers in the types hash table. I'm just getting a random selection from all the sides of the die and adding it to the $avndicerolls variable, which is a collection of all the player's rolls for this wave. 
            $AVNDiceRolls += $AVNDiceRollChoiceTypeWeightArray[(Get-Random -minimum 0 -maximum 5)]
        }
        Write-Host "`nYou rolled the following work types:" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNDiceRolls

        If ($AVNInjectionSpecials.count -gt 0) {
            Do {
                If ($AVNInjectionSpecials.count -lt 1) {
                    Write-Host "`nYou have no more available Specials to inject!" -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNInjectionSpecialsEntry = ""
                    Wait-AVNKeyPress
                } Else {
                    Do {
                        $AVNInjectionSpecialsHashTable = [ordered]@{}
                        $AVNInjectionSpecialsHashTableI = 0
                        $AVNInjectionSpecials | ForEach-Object {
                            $AVNInjectionSpecialsHashTableI++
                            $AVNInjectionSpecialsHashTable.add($AVNInjectionSpecialsHashTableI, $_.name)
                        }

                        Write-Host "`nYou have the following Specials available to inject into your roll:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                        $AVNInjectionSpecialsHashTable

                        $AVNInjectionSpecialsEntry = Read-Host "Enter the number of one you'd like to inject (enter nothing to skip)"

                        #Verifying entry
                        If (($AVNInjectionSpecialsEntry -notmatch "\d+") -and ($AVNInjectionSpecialsEntry -ne "")) {
                            Write-Host "Something seems to be wrong with your entry. Please make sure to enter only the integer that's next to your choice." -foregroundcolor $global:AVNDefaultTextForegroundColor
                            Wait-AVNKeyPress
                        }
                        If (($AVNInjectionSpecialsEntry -notin $AVNInjectionSpecialsHashTable.keys) -and ($AVNInjectionSpecialsEntry -ne "")) {
                            Write-Host "Please only enter the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                            Wait-AVNKeyPress
                        }
                    } Until (($AVNInjectionSpecialsEntry -in $AVNInjectionSpecialsHashTable.keys) -or ($AVNInjectionSpecialsEntry -eq ""))

                    If ($AVNInjectionSpecialsEntry -ne "") {
                        $AVNInjectionSpecialsEntry = [int]$AVNInjectionSpecialsEntry
                        $AVNInjectionSpecials | ForEach-Object {
                            If ($_.name -eq $AVNInjectionSpecialsHashTable.$AVNInjectionSpecialsEntry) {
                                $AVNInjectionSpecialSelected = $_
                            }
                        }
                        Invoke-Expression $AVNInjectionSpecialSelected.effect

                        $AVNPlayerDataSpecialsTempArray = @()
                        $AVNSpecialSingleEntryLimiter = $False
                        $global:AVNSpecials_CurrentPlayer | ForEach-Object {
                            If ($_ -eq $AVNInjectionSpecialSelected.name) {
                                #Skips the first special matching the variable if there are multiple.
                                If ($AVNSpecialSingleEntryLimiter -eq $True) {
                                    $AVNPlayerDataSpecialsTempArray += $_
                                } Else {
                                    $AVNSpecialSingleEntryLimiter = $True
                                }
                            } Else {
                                $AVNPlayerDataSpecialsTempArray += $_
                            }
                        }
                        $global:AVNSpecials_CurrentPlayer = $AVNPlayerDataSpecialsTempArray
                        $AVNInjectionSpecials = GatherAvailableInjectionSpecials

                        Write-Host "`nYou now have the following work types in your roll:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                        $AVNDiceRolls
                    }
                }
            } Until (($AVNInjectionSpecials.count -lt 1) -or ($AVNInjectionSpecialsEntry -eq ""))
        } Else {
            Write-Host "`nYou have no available Specials to inject into your roll." -foregroundcolor $global:AVNDefaultTextForegroundColor
        }

        #Matching dice rolls to defenses and seeing if the player rolled enough of each work type to beat the wave.
        $AVNDiceRollSuccess = $True
        #Cycling through defenses.
        For ($AVNDefI = 0; $AVNDefI -lt (($AVNProjectCurrentStageCurrentWaveHashTable.defenses).count); $AVNDefI++) {
            $AVNDiceRollsLooper = @()
            #For each defense, cycling through the rolled dice to see if any match. Adds all the dice that do NOT match to the $AVNDiceRollsLooper array both for use for additional defenses iterations (assuming one of the dice matches this one) or else for comparing the total count of the looper to the count of the dice to see if any matched at all (in which case they weren't added to the looper).
            For ($AVNDiceI = 0; $AVNDiceI -lt $AVNDiceRolls.count; $AVNDiceI++){
                #Cycling ALL dice through the defense in question. 
                If ($AVNDiceRolls[$AVNDiceI] -ne $AVNProjectCurrentStageCurrentWaveHashTable.defenses[$AVNDefI]) {
                    #If the dice doesn't match the defense, add it to the array of dice to keep for the next round.
                    $AVNDiceRollsLooper += $AVNDiceRolls[$AVNDiceI]
                } Else {
                    #If there's a match, automatically add the rest of the dice to the $AVNDiceRollsLooper array so they aren't discarded like this one. And since I am advancing $AVNDiceI all the way, it should end the parent loop, and the def loop should resume.
                    $AVNDiceI++
                    For ($AVNDiceRolls[$AVNDiceI]; $AVNDiceI -lt $AVNDiceRolls.count; $AVNDiceI++) {
                        $AVNDiceRollsLooper += $AVNDiceRolls[$AVNDiceI]
                    }
                }
            }
            If ($AVNDiceRollsLooper.count -eq $AVNDiceRolls.count) {
                #There was no match. Break the loop to stop its process and set the success flag to false. If the count isn't equal, one of the dice matched the defense and wasn't added to the looper array.
                $AVNDiceRollSuccess = $False
            }
            #Setting the dice rolls to what's in the looper, since that represents everything that was rolled that didn't match, that way the next time through, I'm not counting dice that have already matched. 
            $AVNDiceRolls = $AVNDiceRollsLooper
        }

        If ($True -eq $AVNDiceRollSuccess) {
            If ($AVNProjectCurrentWave -eq 3) {
                $AVNProjectAllWavesComplete = $True
                $AVNProjectCurrentWave++
            } Else {
                Write-Host "`nSuccess! You defeated the current wave." -foregroundcolor $global:AVNDefaultTextForegroundColor
                $AVNProjectCurrentWave++

                #Rolling for counterattack.
                $AVNProjectCounterAttackRoll = Get-Random -minimum 0 -maximum 100
                #Penalty for low team health.
                If ($global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel -ge 3) {
                    $global:AVNProjectCounterAttackRate *= 1.25
                }
                If ($AVNProjectCounterAttackRoll -le ($global:AVNProjectCounterAttackRate * 100)) {
                    Write-Host "The Project Retaliates!" -foregroundcolor $global:AVNDefaultTextForegroundColor
                    Invoke-Expression $AVNProjectCurrentStageCurrentWaveHashTable.counterattack
                    Write-Host $AVNProjectCurrentStageCurrentWaveHashTable.counterattacktext -foregroundcolor $global:AVNDefaultTextForegroundColor
                }
                Wait-AVNKeyPress
            }
        } Else {
            Write-Host "`nYou have failed to defeat the current wave." -foregroundcolor $global:AVNDefaultTextForegroundColor
            $AVNProjectCurrentWave = 4
        }
        #If successful, update wave and proceed. Keep going until wave = 4 I guess, and then set the following to that to complete.
    } Until ($AVNProjectCurrentWave -gt 3)
 
    $AVNProjectPrecedeDeadlineSwitch = $False
    If ($True -eq $AVNProjectAllWavesComplete) {
        If ($AVNProjectCurrentStage -eq 1) {
            $global:AVNCompanyData_CurrentPlayer.ProjectStage1BlocDefeated = 1
            If ((Get-Date) -lt (Get-Date $global:AVNProjectStage1Deadline)) {
                $AVNProjectPrecedeDeadlineSwitch = $True
            }
        } ElseIf ($AVNProjectCurrentStage -eq 2) {
            $global:AVNCompanyData_CurrentPlayer.ProjectStage2BlocDefeated = 1
            If ((Get-Date) -lt (Get-Date $global:AVNProjectStage2Deadline)) {
                $AVNProjectPrecedeDeadlineSwitch = $True
            }
        } ElseIf ($AVNProjectCurrentStage -eq 3) {
            $global:AVNCompanyData_CurrentPlayer.ProjectStage3BlocDefeated = 1
            If ((Get-Date) -lt (Get-Date $global:AVNProjectStage3Deadline)) {
                $AVNProjectPrecedeDeadlineSwitch = $True
            }
        }
        
        #Victory Graphic
        $AVNVictoryAnim = Get-Content ($AVNRootPath + "\Media\AVNVictoryAnim")
        $AVNVictoryAnim  | ForEach-Object {
            Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
            Start-Sleep -Milliseconds 20
        }
        
        #Already -= 2 at the beginning. Player's only lose that if they fail.
        $global:AVNCompanyData_CurrentPlayer.clienthealth += 2

        If ($AVNProjectCurrentStage -lt 3) {
            Write-Host "`n⣿ADVENTURENET⣿Project⣿Success!⣿`n`nYou completed your bloc of stage" $AVNProjectCurrentStage "of the project." -foregroundcolor $global:AVNDefaultTextForegroundColor
            If ($True -eq $AVNProjectPrecedeDeadlineSwitch) {
                Write-Host "`nFor completing this bloc prior to the stage's deadline, you..." -foregroundcolor $global:AVNDefaultTextForegroundColor
                #Invoke bonuses
                $global:AVNPlayerData_CurrentPlayer.globalnotice = "defeated a Project Stage before its deadline."
                $global:AVNPlayerData_CurrentPlayer.kudos += 5
                $global:AVNCompanyData_CurrentPlayer.clienthealth += 2
            } Else {
                $global:AVNPlayerData_CurrentPlayer.globalnotice = "defeated a Project Stage."
                $global:AVNPlayerData_CurrentPlayer.kudos += 2
            }
            Wait-AVNKeyPress
        } Else {
            Write-Host "`n⣿ADVENTURENET⣿Project⣿Victory!⣿`n`nYou completed your bloc of the final stage of the project! `nThe season is now complete, and all tallies, once players finish all remaining turns, are final." -foregroundcolor $global:AVNDefaultTextForegroundColor

            #########################################################################################Need to fix this. The player has only finished their bloc. The season's only over once all blocs are finished.


            If ($True -eq $AVNProjectPrecedeDeadlineSwitch) {
                Write-Host "`nAnd for completing it prior to its deadline, you..." -foregroundcolor $global:AVNDefaultTextForegroundColor
                #Invoke bonuses
                $global:AVNPlayerData_CurrentPlayer.globalnotice = "defeated the final Project Stage and finished the season before its deadline."
                $global:AVNPlayerData_CurrentPlayer.kudos += 5
                $global:AVNCompanyData_CurrentPlayer.clienthealth += 2
            } Else {
                $global:AVNPlayerData_CurrentPlayer.globalnotice = "defeated the final Project Stage and finished the season."
                $global:AVNPlayerData_CurrentPlayer.kudos += 2
            }
            Wait-AVNKeyPress
        }
    } Else {
        Write-Host "`n⣿ADVENTURENET⣿Project⣿Failure⣿`n`nThe Project, in its immensity, has overwhelmed you." -foregroundcolor $global:AVNDefaultTextForegroundColor
        $global:AVNPlayerData_CurrentPlayer.globalnotice = "was overcome by a project bloc."
    }
    ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
}
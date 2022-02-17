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
Function Close-AVNServiceTicket {
    <#
    Parameters for any special conditions, like if you have a special that changes what you're looking for or something.
    Give the option to run away? That'd only help cases where there's also a negative consequence in addition to the technical question that'll be generated.
    Data for encounters--like what the monsters are and what they do and say and weaknesses and all--will be in a common data file.
    Most text comes from the encounters hash per mob. If I leave some field empty, I can have a separate default text table and use that instead.
    #>

    Get-AVNConfig

    Write-Host "`n    ███████ ███████ ██████  ██    ██ ██  ██████ ███████     ████████ ██  ██████ ██   ██ ███████ ████████    `n    ██      ██      ██   ██ ██    ██ ██ ██      ██             ██    ██ ██      ██  ██  ██         ██       `n    ███████ █████   ██████  ██    ██ ██ ██      █████          ██    ██ ██      █████   █████      ██       `n         ██ ██      ██   ██  ██  ██  ██ ██      ██             ██    ██ ██      ██  ██  ██         ██       `n    ███████ ███████ ██   ██   ████   ██  ██████ ███████        ██    ██  ██████ ██   ██ ███████    ██       `n`n" -foregroundcolor $global:AVNDefaultBannerForegroundColor

    If ($global:AVNServiceTickets_CurrentPlayer.count -lt 1) { 
        Throw "You don't have any service tickets!"
    } ElseIf ($global:AVNPlayerData_CurrentPlayer.turns -lt 1) {
        Write-Host "You don't have any turns available!" -foregroundcolor $global:AVNDefaultTextForegroundColor
    } Else {
        #Prep stuff
        #Decreasing turns. 
        $global:AVNPlayerData_CurrentPlayer.turns -= 1

        #Getting encounters
        #Yields the $global:AVNServiceTicketEncounters array with a hash table for each possible encounter.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\uhGNpSAZCzIt")
        $AVNDataFileContent | ForEach-Object {
        Invoke-Expression $_
        }
        <#
        Old
        (Get-Content -path ($global:AVNRootPath + "\uhGNpSAZCzIt")) | ForEach-Object {
            Invoke-Expression $_
        }
        #>

        #Getting specials
        #Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
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

        Function GatherAvailablePreEmptiveSpecials {
            #Cycling through the player's specials and creating a full version of it in a temporary variable to be used in this function.
            #If this goes in the function, I just have to remove the special from the global variable and then run the function to get the current ones again.
            $avnpremptivespecials = @()
            $global:AVNSpecials_CurrentPlayer | ForEach-Object {
                ForEach ($AVNSTRawSpecial in $AVNSpecials) {
                    If (($AVNSTRawSpecial.name -eq $_) -and ($AVNSTRawSpecial.type -eq 'preemptive')) {
                        $avnpremptivespecials += $AVNSTRawSpecial
                    }
                }
            }
            ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
            Get-AVNConfig
            Return $avnpremptivespecials
        }
        #Note that it returns only the value. This is what you should run later when you need to get them again.
        $AVNPreEmptiveSpecials = GatherAvailablePreEmptiveSpecials

        Function GatherAvailableInterruptSpecials {
            #Cycling through the player's specials and creating a full version of it in a temporary variable to be used in this function.
            #If this goes in the function, I just have to remove the special from the global variable and then run the function to get the current ones again.
            $avninterruptspecials = @()
            $global:AVNSpecials_CurrentPlayer | ForEach-Object {
                ForEach ($AVNSTRawSpecial in $AVNSpecials) {
                    If (($AVNSTRawSpecial.name -eq $_) -and ($AVNSTRawSpecial.type -eq 'interrupt')) {
                        $avninterruptspecials += $AVNSTRawSpecial
                    }
                }
            }
            ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
            Get-AVNConfig
            Return $avninterruptspecials
        }
        #Note that it returns only the value. This is what you should run later when you need to get them again.
        $AVNInterruptSpecials = GatherAvailableInterruptSpecials

        Function GatherAvailableInjectionSpecials {
            $AVNInjectionSpecials = @()
            $global:AVNSpecials_CurrentPlayer | ForEach-Object {
                ForEach ($AVNSTRawSpecial in $AVNSpecials) {
                    If (($AVNSTRawSpecial.name -eq $_) -and ($AVNSTRawSpecial.type -eq 'injection')) {
                        $AVNInjectionSpecials += $AVNSTRawSpecial
                    }
                }
            }
            ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
            Get-AVNConfig
            Return $AVNInjectionSpecials
        }
        $AVNInjectionSpecials = GatherAvailableInjectionSpecials

        #Rolling for either a service ticket or a special and assigning random encounter hashtable from those results to $AVNPossibleEncounters. 
        $AVNSTTypeRoll = Get-Random -Minimum 0 -Maximum 100
        #Applying penalty to special chance.
        If ($global:AVNCompanyDataCommon.teamhealth -lt $global:AVNPenaltyThresholdTwo) {
            $global:AVNServiceTicketSpecialRate *= .5
        }
        #Service ticket
        If ($AVNSTTypeRoll -gt ($global:AVNServiceTicketSpecialRate * 100)) {
            #Prepping all info.
            #Setting this encounter as a technical question by default in case the user hits ctrl+c or something. It will go back to an answered service ticket if the player succeeds. 
            $global:AVNCompanyData_CurrentPlayer.TechnicalQuestionsAdded += 1
            #Same thing for team health hit. If the player succeeds, +1 gets added back so that it's total -1 instead of -2.
            $global:AVNCompanyData_CurrentPlayer.teamhealth -= 2
            $global:AVNCompanyData_CurrentPlayer.clienthealth -= 2
            #Removing the oldest service ticket from the player's service ticket array.
            If ($global:AVNServiceTickets_CurrentPlayer.count -gt 1) {
                $global:AVNServiceTickets_CurrentPlayer = $global:AVNServiceTickets_CurrentPlayer[1..($global:AVNServiceTickets_CurrentPlayer.count-1)]
            } Else {
                #If there's only one ticket in the array just clearing the array.
                $global:AVNServiceTickets_CurrentPlayer = @()
            }
            #Writing so that if the player tries to use ctrl+c to get out of it, data has already been removed. 
            ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
            Get-AVNConfig

            #Encounter
            #Creates an array of only array contents that match the reqprojectstage.
            $AVNSTPossibleEncounters = $global:AVNServiceTicketEncounters | Where-Object {$_.ReqProjectStage -eq $global:AVNCompanyDataCommon.CurrentStage}
            $AVNSTCurrentEncounter = Get-Random -InputObject $AVNSTPossibleEncounters

            Write-Host $AVNSTCurrentEncounter.IntroductionText -foregroundcolor $global:AVNDefaultTextForegroundColor
            $AVNSTCurrentEncounter

            #Getting the $AVNDiceValues array.
            $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\bGBIuKWniXYw")
            $AVNDataFileContent | ForEach-Object {
            Invoke-Expression $_
            }
            <#
            Old way
            (Get-Content -path ($global:AVNRootPath + "\bGBIuKWniXYw")) | ForEach-Object {
                Invoke-Expression $_
            }
            #>

            #Gathering all dice available to the player.
            #Dice that are added as specials during the encounter. There are the complete hashes of the actual dice. Leave it outside of the loop because these will be added later on in the script.
            $AVNSTSpecialDice = @()
            Function GatherAvailableDice {
                $AVNSTAvailableDice = [ordered]@{}
                [int]$AvailableDiceI = 0
                $global:AVNDicePerm_CurrentPlayer | ForEach-Object {
                    $AvailableDiceI++
                    $AVNSTAvailableDice.add($AvailableDiceI, $_)
                }
                $global:AVNDiceDaily_CurrentPlayer | ForEach-Object {
                    $AvailableDiceI++
                    $AVNSTAvailableDice.add($AvailableDiceI, $_)
                }
                If ($AVNSTSpecialDice.count -gt 0) {
                    $AVNSTSpecialDice | ForEach-Object {
                        $AvailableDiceI++
                        $AVNSTAvailableDice.add($AvailableDiceI, $_)
                    }
                }

                ###I did an array for these instead of working with the hash table above. I fixed it. Need to test.
                #Penalties from client health being low. Removing dice from available dice.
                $ANVSTUnavailableDice = [ordered]@{}
                If ($global:AVNCompanyDataCommon.clienthealth -lt $global:AVNPenaltyThresholdFive) {
                    $AVNSTDicePenaltyIterations = 3
                } ElseIf ($global:AVNCompanyDataCommon.clienthealth -lt $global:AVNPenaltyThresholdThree) {
                    $AVNSTDicePenaltyIterations = 2
                } ElseIf ($global:AVNCompanyDataCommon.clienthealth -lt $global:AVNPenaltyThresholdOne) {
                    $AVNSTDicePenaltyIterations = 1
                }
                While (($AVNSTDicePenaltyIterations -gt 0) -and ($AVNSTAvailableDice.count -gt 1)) {$AVNSTAvailableDiceTemporaryHashTable = [ordered]@{}
                    $AVNDicePenaltyRandomizer = $AVNSTAvailableDice.keys | Get-Random
                    $AVNSTAvailableDice.keys | ForEach-Object {
                        If ($_ -ne $AVNDicePenaltyRandomizer) {
                            $AVNSTAvailableDiceTemporaryHashTable.add($_, $AVNSTAvailableDice.$_)
                        } Else {
                            $ANVSTUnavailableDice.add($_, $AVNSTAvailableDice.$_)
                        }
                    }
                    $AVNSTAvailableDice = $AVNSTAvailableDiceTemporaryHashTable
                    $AVNSTDicePenaltyIterations--
                }
                If (($AVNSTDicePenaltyIterations -gt 0) -and ($AVNSTAvailableDice.count -eq 1)) {
                    $AVNSTAvailableDice = [ordered]@{}
                    Write-Host "`nLow client health has removed all of your available dice! Have you trained today?"
                } ElseIf ($AVNSTDicePenaltyIterations -gt 0) {
                    Write-Host "`nLow client health has rendered the following dice unusable for this encounter:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $ANVSTUnavailableDice.keys | ForEach-Object {
                        Write-Host $ANVSTUnavailableDice.$_
                    }
                }                
                Return $AVNSTAvailableDice
            }
            $AVNSTAvailableDice = GatherAvailableDice

            #Getting all possible defense types for this encounter
            $AVNSTCurrentEncounterPossibleDefenses = @()
            $AVNSTCurrentEncounter.keys | ForEach-Object {
                If ($_ -match "def.") {
                    #The value of the key to see if it should be added
                    If ($True -eq $AVNSTCurrentEncounter[$_]) {
                        $AVNSTCurrentEncounterPossibleDefenses += ($_ -replace "def", "")
                    }
                }
            }
            
            #Now that I have defenses, need to write them appropriately and give the player the option to use his dice on them.
            #Accumulates the number of waves (not the number of defenses in each wave)
            If ($AVNSTCurrentEncounter.wave3 -gt 0) {
                $AVNSTTotalWaves = 3
            } ElseIf ($AVNSTCurrentEncounter.wave2 -gt 0) {
                $AVNSTTotalWaves = 2
            } ElseIf ($AVNSTCurrentEncounter.wave1 -gt 0) {
                $AVNSTTotalWaves = 1
            }

            If ($AVNSTTotalWaves -lt 2) {
                Write-Host "Prepare yourself. The" $AVNSTCurrentEncounter.name "has only $AVNSTTotalWaves wave of defense." -foregroundcolor $global:AVNDefaultTextForegroundColor
            } Else {
                Write-Host "Prepare yourself. The" $AVNSTCurrentEncounter.name "has $AVNSTTotalWaves waves of defenses." -foregroundcolor $global:AVNDefaultTextForegroundColor
            }

            $AVNSTCurrentWave = 1
            $AVNSTAllWavesComplete = $False
            Do {
                #Cycles waves until all waves complete. Includes rolls. If the player's roll succeeds for a wave, increase the wave integer, invoke the wave's counterattack, and circle back through this loop with the appropriate wave criteria.
                Do {
                    #Cycles choice entries until the player rolls/attacks. Includes info and pre-emptive special use.
                    Do {
                        #Cycles entries until the player's entry is valid
                        #Checking for and then adding preemptive options for the encounter. Not sure about having a run option or not.

                        #Determine current wave info and set a variable for it that can be used by subsequent loops.
                        $AVNSTCurrentWaveDefenses = @()
                        If ($AVNSTCurrentWave -eq 1) {
                            For ($I = 0; $I -lt $AVNSTCurrentEncounter.wave1; $I++) {
                                #Adding a random selection of the possible defense types
                                $AVNSTCurrentWaveDefenses += (Get-Random -InputObject $AVNSTCurrentEncounterPossibleDefenses)
                            }
                        } ElseIf ($AVNSTCurrentWave -eq 2) {
                            For ($I = 0; $I -lt $AVNSTCurrentEncounter.wave2; $I++) {
                                #Adding a random selection of the possible defense types
                                $AVNSTCurrentWaveDefenses += (Get-Random -InputObject $AVNSTCurrentEncounterPossibleDefenses)
                            }
                        } ElseIf ($AVNSTCurrentWave -eq 3) {
                            For ($I = 0; $I -lt $AVNSTCurrentEncounter.wave3; $I++) {
                                #Adding a random selection of the possible defense types
                                $AVNSTCurrentWaveDefenses += (Get-Random -InputObject $AVNSTCurrentEncounterPossibleDefenses)
                            }
                        }

                        #Default choices.
                        [int]$AVNOptionI = 0
                        $AVNSTCurrentWaveOptions = [ordered]@{
                            '?' = 'Show information about your options.'
                            'R' = 'Run away!'
                        }
                        If ($AVNSTAvailableDice.count -gt 0) {
                            $AVNOptionI++
                            $AVNSTCurrentWaveOptions.add($AVNOptionI, 'Attack!')
                        } Else {
                            Write-Host "You have no dice with which to attack!" -foregroundcolor $global:AVNDefaultTextForegroundColor
                        }
                        If (($True -eq $AVNSTCurrentEncounter.opportunity) -and ($global:AVNPlayerData_CurrentPlayer.opportunities -gt 0)) {
                            $AVNOptionI++
                            $AVNSTCurrentWaveOptions.add($AVNOptionI, 'Opportunity')
                        } 
                        #Adding specials to the choices. Changes based on what wave we're on. Also adds all the ints of these specials to $AVNSpecialIntegers, so I can know a special has been chosen later. I might not need, this, though, if I only do ?, attack, and specials. I'd always know the range, and the ints of those options would be constant.
                        If ($AVNSTCurrentWave -eq 1) {
                            $AVNSpecialIntegers = @()
                            If ($AVNPreEmptiveSpecials.count -gt 0) {
                                $AVNPreEmptiveSpecials | ForEach-Object {
                                    $AVNOptionI++
                                    $AVNSpecialIntegers += $AVNOptionI
                                    $AVNSTCurrentWaveOptions.add($AVNOptionI, $_.name)
                                }
                            }
                        } Else {
                            $AVNSpecialIntegers = @()
                            If ($AVNInterruptSpecials.count -gt 0) {
                                $AVNInterruptSpecials | ForEach-Object {
                                    $AVNOptionI++
                                    $AVNSpecialIntegers += $AVNOptionI
                                    $AVNSTCurrentWaveOptions.add($AVNOptionI, $_.name)
                                }
                            }
                        }



                        #Account for singles and multiples in your verbage.
                        Write-Host "Defenses for this wave are:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                        $AVNSTCurrentWaveDefenses

                        Write-Host "What would you like to do?" -foregroundcolor $global:AVNDefaultTextForegroundColor
                        $AVNSTCurrentWaveOptions
                        
                        $AVNSTActionEntry = Read-Host "`nEnter your choice"
                        #Making sure the entry is valid.
                        If (($AVNSTActionEntry -notmatch "\d+") -and ($AVNSTActionEntry -ne "?") -and ($AVNSTActionEntry -ne "r")) {
                            Write-Host "Something seems to be wrong with your entry. Please make sure to enter only the integer that's next to your choice or a single ?." -foregroundcolor $global:AVNDefaultTextForegroundColor
                            Wait-AVNKeyPress
                        }
                        If ($AVNSTActionEntry -notin $AVNSTCurrentWaveOptions.keys) {
                            Write-Host "Please only enter the integer of an item in the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                            Wait-AVNKeyPress
                        }
                    } Until ($AVNSTActionEntry -in $AVNSTCurrentWaveOptions.keys)
                    #Converting the string that read-host creates into an int to match the $AVNSTCurrentWaveOptions keys.
                    If (($AVNSTActionEntry -ne "?") -and ($AVNSTActionEntry -ne "r")) {
                        $AVNSTActionEntry = [int]$AVNSTActionEntry
                    }
                    #Branches based on what's entered.
                    If ($AVNSTActionEntry -eq "r") {
                        Write-Host "You ran away, converting your adversary into a Technical Question." -foregroundcolor $global:AVNDefaultTextForegroundColor
                        Return
                    }
                    If ($AVNSTActionEntry -eq "?") {
                        Get-AVNHelp -dice
                    }
                    If ($AVNSTCurrentWaveOptions.$AVNSTActionEntry -eq 'Opportunity') {
                        Write-Host "You have sent this service ticket to the procurement department! As a result, you've saved the engineer team some stress. Service tickets reduced by 1 without reducing team health." -foregroundcolor $global:AVNDefaultTextForegroundColor
                        #Adding back health and technical question default removals. Sending off to an opportunity reduces turns and service ticket counts only.
                        $global:AVNCompanyData_CurrentPlayer.TechnicalQuestionsAdded -= 1
                        $global:AVNCompanyData_CurrentPlayer.teamhealth += 2
                        $global:AVNCompanyData_CurrentPlayer.clienthealth += 2
                        #Removing the opportunity from the player's alottment.
                        $global:AVNPlayerData_CurrentPlayer.opportunities -= 1
                        Return
                    }
                    If ($AVNSTActionEntry -in $AVNSpecialIntegers) {
                        #Displaying the option. 
                        
                        If ($AVNSTCurrentWave -eq 1) {
                            $AVNPreEmptiveSpecials | ForEach-Object {
                                If ($_.name -eq $AVNSTCurrentWaveOptions.$AVNSTActionEntry) {
                                    $AVNSTChosenSpecial = $_
                                }
                            }
                        } Else {
                            $AVNInterruptSpecials | ForEach-Object {
                                If ($_.name -eq $AVNSTCurrentWaveOptions.$AVNSTActionEntry) {
                                    $AVNSTChosenSpecial = $_
                                }
                            }
                        }   
                        
                        Write-Host "You used your " $AVNSTChosenSpecial.name -foregroundcolor $global:AVNDefaultTextForegroundColor
                        $AVNSTChosenSpecial.description
                        Invoke-Expression $AVNSTChosenSpecial.effect

                        #Removing the special from the player's data variable by adding all specials that don't match the chosen variable to a temporary array and then making the normal array mirror the temporary array.
                        $AVNPlayerDataSpecialsTempArray = @()
                        $AVNSTSingleEntryLimiter = $False
                        $global:AVNSpecials_CurrentPlayer | ForEach-Object {
                            If ($_ -eq $AVNSTChosenSpecial.name) {
                                #Skips the first special matching the variable if there are multiple.
                                If ($AVNSTSingleEntryLimiter -eq $True) {
                                    $AVNPlayerDataSpecialsTempArray += $_
                                } Else {
                                    $AVNSTSingleEntryLimiter = $True
                                }
                            } Else {
                                $AVNPlayerDataSpecialsTempArray += $_
                            }
                        }
                        $global:AVNSpecials_CurrentPlayer = $AVNPlayerDataSpecialsTempArray
                        #End with getting all specials again, which will remove the specials item from the pre-emptive specials array.
                        If ($AVNSTCurrentWave -eq 1) {
                            $AVNPreEmptiveSpecials = GatherAvailablePreEmptiveSpecials
                        } Else {
                            $AVNInterruptSpecials = GatherAvailableInterruptSpecials
                        }
                        Wait-AVNKeypress
                    }
                } Until ($AVNSTCurrentWaveOptions.$AVNSTActionEntry -eq 'Attack!')
                #With this, once the player chooses attack, the player can keep doing other things beforehand.

                #Getting inputted dice by their keys in $AVNSTAvailableDice, creating a simple array of the ints entered, removing hashes of those dice by their int.
                Do {
                    Write-Host "Wave 1 defenses are:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNSTCurrentWaveDefenses
                    Write-Host "`nYou have the following dice available to roll:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNSTAvailableDice
                    [string]$AVNDiceRollChoice = Read-Host "Choose which die or dice you'd like to roll by its number in the above table; for multiple, separate numbers by a comma (ex: 1,2); enter ? to display work-type value alottment per dice"
                    If ($AVNDiceRollChoice -eq '?') {
                        Write-Host "Dice info blah blah blah for each of the player's dice" -foregroundcolor $global:AVNDefaultTextForegroundColor
                        $AVNDiceRollChoicePass = $False
                        Wait-AVNKeyPress
                    } Else {
                        $AVNDiceRollChoicePass = $True
                        $AVNDiceRollChoiceArray = $AVNDiceRollChoice -split ","
                        $AVNDiceRollChoiceArrayComparer = $AVNDiceRollChoiceArray | Select-Object -unique
                        If ($AVNDiceRollChoiceArray.count -ne $AVNDiceRollChoiceArrayComparer.count) {
                            Write-Host "You appear to have entered the same value more than once. You can only roll any dice once without an appropriate special." -foregroundcolor $global:AVNDefaultTextForegroundColor
                            $AVNDiceRollChoicePass = $False
                            #A special might change this.
                            Wait-AVNKeyPress
                        }
                        $AVNDiceRollChoiceArray | ForEach-Object {
                            If ($_ -notmatch "\d{1,}") {
                                $AVNDiceRollChoicePass = $False
                                Write-Host "Something is odd about your entry. Please make sure to enter using the appropriate format. No letters or special characters are permitted, and if you're trying to get information about the dice, please enter a solitary ?." -foregroundcolor $global:AVNDefaultTextForegroundColor
                                Wait-AVNKeyPress
                            }
                            If ([int]$_ -notin $AVNSTAvailableDice.keys){
                                $AVNDiceRollChoicePass = $False
                                Write-Host "Please only enter a number that's in your list of available dice." -foregroundcolor $global:AVNDefaultTextForegroundColor
                                Wait-AVNKeyPress
                            }
                        }
                    }
                } Until ($AVNDiceRollChoicePass -eq $True)
                $AVNDiceRolls = @()
                $AVNDiceRollChoiceArray | ForEach-Object {
                    #Converting the current int that the person entered into the worktype that it represents.
                    $AVNSTRollChoiceType = $AVNSTAvailableDice.([int]$_)
                    $AVNDiceRollChoiceTypeHashTable = $AVNDiceValues.$AVNSTRollChoiceType
                    #Removing it from the available dice by the int that the player entered.
                    $AVNSTAvailableDice.remove([int]$_)
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

                                Write-Host "nYou now have the following work types in your roll:" -foregroundcolor $global:AVNDefaultTextForegroundColor
                                $AVNDiceRolls
                            }
                        }
                    } Until (($AVNInjectionSpecials.count -lt 1) -or ($AVNInjectionSpecialsEntry -eq ""))
                } Else {
                    Write-Host "You have no available Specials to inject into your roll." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNDiceRolls
                }

                #Matching dice rolls to defenses and seeing if the player rolled enough of each work type to beat the wave.
                $AVNDiceRollSuccess = $True
                #Cycling through defenses.
                For ($AVNDefI = 0; $AVNDefI -lt ($AVNSTCurrentWaveDefenses.count); $AVNDefI++) {
                    $AVNDiceRollsLooper = @()
                    #For each defense, cycling through the rolled dice to see if any match. Adds all the dice that do NOT match to the $AVNDiceRollsLooper array both for use for additional defenses iterations (assuming one of the dice matches this one) or else for comparing the total count of the looper to the count of the dice to see if any matched at all (in which case they weren't added to the looper).
                    For ($AVNDiceI = 0; $AVNDiceI -lt $AVNDiceRolls.count; $AVNDiceI++){
                        #Cycling ALL dice through the defense in question. 
                        If ($AVNDiceRolls[$AVNDiceI] -ne $AVNSTCurrentWaveDefenses[$AVNDefI]) {
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
                    #Setting the dice rolls to what's in the looper, since that represents everything that was rolled that didn't match--that way the next time through, I'm not counting dice that have already matched defenses. 
                    $AVNDiceRolls = $AVNDiceRollsLooper
                }

                If ($True -eq $AVNDiceRollSuccess) {
                    If ($AVNSTCurrentWave -eq $AVNSTTotalWaves) {
                        $AVNSTAllWavesComplete = $True
                        $AVNSTCurrentWave++
                    } Else {
                        Write-Host "Success! You defeated the current wave." -foregroundcolor $global:AVNDefaultTextForegroundColor
                        $AVNSTCurrentWave++
                        Wait-AVNKeyPress
                    }
                } Else {
                    Write-Host "You failed to defeat the current wave." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNSTCurrentWave = ($AVNSTTotalWaves + 1)
                    Wait-AVNKeyPress
                }
            } Until ($AVNSTCurrentWave -gt $AVNSTTotalWaves)
            #After this, if $AVNSTAllWavesComplete -eq $True, the player succeded, and if not, the player failed.

            #Results of the encounter.
            If ($AVNSTAllWavesComplete -eq $True) {
                #Success results
                Write-Host "You have defeated all waves!" -foregroundcolor $global:AVNDefaultTextForegroundColor
                $AVNSTCurrentEncounter.deathtext

                #Gif award
                If ($global:AVNCompanyDataCommon.CurrentStage = 1) {
                    $AVNSTGifAwardMin = $global:AVNSTGifAwardMultiplier * 1
                    $AVNSTGifAwardMax = $global:AVNSTGifAwardMultiplier * 3
                } ElseIf ($global:AVNCompanyDataCommon.CurrentStage = 2) {
                    $AVNSTGifAwardMin = $global:AVNSTGifAwardMultiplier * 2
                    $AVNSTGifAwardMax = $global:AVNSTGifAwardMultiplier * 4
                } ElseIf ($global:AVNCompanyDataCommon.CurrentStage = 3) {
                    $AVNSTGifAwardMin = $global:AVNSTGifAwardMultiplier * 3
                    $AVNSTGifAwardMax = $global:AVNSTGifAwardMultiplier * 5
                }
                $AVNSTGifAwardRoll = Get-Random -minimum $AVNSTGifAwardMin -maximum $AVNSTGifAwardMax
                $global:AVNPlayerData_CurrentPlayer.gifs += $AVNSTGifAwardRoll
                Write-Host "You found " $AVNSTGifAwardRoll "GIFs!" -foregroundcolor $global:AVNDefaultTextForegroundColor

                $AVNInjectionSpecials = @()
                $AVNSpecials | ForEach-Object {
                    If ($_.type -eq "injection") {
                        $AVNInjectionSpecials += $_
                    }
                }
                $AVNInjectionRewardRollMax = ($AVNInjectionSpecials.count -1) / $global:AVNServiceTicketInjectionSpecialRewardRate
                $AVNInjectionRewardRoll = Get-Random -minimum 0 -maximum $AVNInjectionRewardRollMax
                If ($AVNInjectionRewardRoll -le ($AVNInjectionSpecials.count -1)) {
                    $global:AVNSpecials_CurrentPlayer += $AVNInjectionSpecials[$AVNInjectionRewardRoll].name
                    Write-Host "You found the following interrupt special!" -foregroundcolor $global:AVNDefaultTextForegroundColor
                    $AVNInjectionSpecials[$AVNInjectionRewardRoll].name
                }

                $global:AVNCompanyData_CurrentPlayer.TechnicalQuestionsAdded -= 1
                #I have already decreased this by two at the beginning, similar to the above. This changes it to just -1 because of the service ticket success. Answering technical questions increases team health the other +1?
                $global:AVNCompanyData_CurrentPlayer.teamhealth += 1
                $global:AVNCompanyData_CurrentPlayer.clienthealth += 1
                $global:AVNPlayerData_CurrentPlayer.kudos += 1
                Wait-AVNKeyPress
            } Else {
                #Failure results. 
                Write-Host "You failed to close the Service Ticket." -foregroundcolor $global:AVNDefaultTextForegroundColor
                $AVNSTCurrentEncounter.failuretext
                Wait-AVNKeyPress
                #The ticket has already been sent to technical questions and decreased team health by 2 by default, so this is mostly going to be for extra detriments and will depend on what encounter you're facing.
            }
        } Else {
            #If the player gets a roll for a special, goes through the available ones for a random one and assigns just the name to the array in the player's data variable.
            $AVNSTNonPurchaseSpecials = @()
            #Filtering out purchase-only specials
            $AVNSpecials | ForEach-Object {
                If ($_.teamscost -eq 0) {
                    $AVNSTNonPurchaseSpecials += $_
                }
            }
            If ($AVNSTNonPurchaseSpecials.count -lt 2) {
                $AVNSTSpecialRoll = 0
            } Else {
                $AVNSTSpecialRoll = Get-Random -minimum 0 -maximum ($AVNSTNonPurchaseSpecials.count - 1)
            }
            $AVNSTAttainedSpecial = $AVNSTNonPurchaseSpecials[$AVNSTSpecialRoll]

            Write-Host "You found a" $AVNSTAttainedSpecial.Name "`n" $AVNSTAttainedSpecial.description -foregroundcolor $global:AVNDefaultTextForegroundColor
            If ($AVNSTAttainedSpecial.type -eq "Instant") {
                Invoke-Expression $AVNSTAttainedSpecial.effect
                $global:AVNPlayerData_CurrentPlayer.globalnotice = $AVNSTAttainedSpecial.globalnotice
            } Else {
                Write-Host "You store the" $AVNSTAttainedSpecial.Name "away for later use." -foregroundcolor $global:AVNDefaultTextForegroundColor
                $global:AVNSpecials_CurrentPlayer += $AVNSTAttainedSpecial.Name
            }
        }

        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
    }
}
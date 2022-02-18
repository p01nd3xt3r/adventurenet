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
Function Invoke-AVNSignOn {
    Get-AVNConfig

    #Making sure the player can't sign in if the season has ended. They can still finish all their turns, though.
    If ($True -eq $global:AVNCompanyDataCommon.SeasonComplete) {
        Throw "The season is over! A new season will need to be generated before you can sign in again."
    }

    #Checking if it's been 24 hours since the last Invoke-AVNSignOn before running everything.
    #Old $AVNLastSignOnInterval = New-Timespan –Start $global:AVNPlayerData_CurrentPlayer.lastsignon –End (Get-Date)
    #Old If ($AVNLastSignOnInterval -gt (New-TimeSpan -Hours 24)) {
    $AVNLastSignOnDate = (Get-Date $global:AVNPlayerData_CurrentPlayer.lastsignon).date
    If ((Get-Date).date -gt $AVNLastSignOnDate) {
        #Invisible stuff
        #If first sign on of the season, adding project waves.
        If ($True -eq $global:AVNPlayerData_CurrentPlayer.seasonfirstrun) {
            Add-AVNProjectWaves -system
            #Refreshing variables
            Get-AVNConfig
        }
        
        #Turns assignment:
        $global:AVNPlayerData_CurrentPlayer.turns = $global:AVNTurnsPerDay

        #Identify each service ticket older than the above and then shift the array to not include it. These should all be the first in the array.
        #Rationalization for converting tickets to tech questions here: the player needs training to do the project; the player needs to answer service tickets daily to not end up with technical questions the next day (for training), the player needs to do the project to complete the season and to not get pinged, the player gets kudos for all these things.
        $AVNDate = Get-Date
        $AVNServiceTicketsWithinInterval = @()
        For ($I = 0; $I -lt $global:AVNServiceTickets_CurrentPlayer.count; $I++) {
            $AVNServiceTicketIntervalCheck = New-TimeSpan -start $global:AVNServiceTickets_CurrentPlayer[$I] -end $AVNDate
            $AVNServiceTicketIntervalThreshold = New-TimeSpan -days $global:AVNTechnicalQuestionsThreshold
            If ($AVNServiceTicketIntervalCheck -lt $AVNServiceTicketIntervalThreshold) {
                $AVNServiceTicketsWithinInterval += $global:AVNServiceTickets_CurrentPlayer[$I]
            } Else {
                $global:AVNCompanyData_CurrentPlayer.technicalquestionsadded += 1
                $global:AVNCompanyData_CurrentPlayer.clienthealth -= 1
            }
        }
        #Making the current array only the good tickets.
        $global:AVNServiceTickets_CurrentPlayer = $AVNServiceTicketsWithinInterval

        #Daily service ticket assignment:
        For ($I = 0; $I -lt $global:AVNServiceTicketsPerDay; $I++) {
            $global:AVNServiceTickets_CurrentPlayer += $AVNDate
        }

        #Resetting Project Stage attempts
        $global:AVNPlayerData_CurrentPlayer.ProjectStageAttempts = 0

        #Training:
        #I'm not allowing players to amass training. If you miss it that day, you miss it.
        $global:AVNPlayerData_CurrentPlayer.training = $global:AVNTrainingPerDay
        #Changing last sign on to now.
        $global:AVNPlayerData_CurrentPlayer.lastsignon = $AVNDate
        $global:AVNPlayerData_CurrentPlayer.opportunities = $global:AVNOpportunitiesPerDay
        
        #Intro Graphic
        $AVNIntroAnim = Get-Content ($AVNRootPath + "\Media\AVNIntroAnim")
        $AVNIntroAnim  | ForEach-Object {
            Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
            Start-Sleep -Milliseconds 20
        }
        Wait-AVNKeyPress

        #Running dice allottment. I had this as a separate function, but I think it's better here.
        #Dice types table. Not making this a global at the moment.
        $AVNDiceTypes = @{
            1 = "Microsoft365"
            2 = "Datto"
            3 = "MimecastUmbrella"
            4 = "Windows"
            5 = "HuntressDefender"
            6 = "CoreValues"
            7 = "ITGlue"
        }

        #Generating random dice
        #Have some kind of animation for the roll process.
        #Show information about the dice if asked. Can use the hash.
        $global:AVNDiceDaily_CurrentPlayer = @()
        If ($global:AVNCompanyDataCommon.teamhealth -ge $global:AVNPenaltyThresholdOne) {
            $AVNDiceOffer = [ordered]@{}
            $AVNAllottmentRoll = Get-Random -count $global:AVNDiceOfferingPerDay -maximum ($AVNDiceTypes.count) -minimum 1
            [int]$AVNDiceOfferNumber = 0
            
            $AVNAllottmentRoll | ForEach-Object {
                $AVNDiceOfferNumber++
                $AVNDiceOffer.add($AVNDiceOfferNumber, $AVNDiceTypes[$_])
            }
            Write-Host "`nChoose $global:AVNDiceChoicePerDay of the following to keep for the day:" -foregroundcolor $global:AVNDefaultTextForegroundColor

            $AVNChoiceText = @("first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth")
            [int]$AVNDiceChoiceNumber = -1
            For ($I = 0; $I -lt $global:AVNDiceChoicePerDay; $I++) {
                Do {
                    $AVNDiceOffer
                    $AVNDiceChoiceNumber = Read-Host ("`nEnter the number next to your " + $AVNChoiceText[$I] + " choice")
                    If ($AVNDiceChoiceNumber -notin $AVNDiceOffer.keys) {
                        Write-Host "`nPlease choose a number from the list." -foregroundcolor $global:AVNDefaultTextForegroundColor
                    }
                } Until ($AVNDiceChoiceNumber -in $AVNDiceOffer.keys)
            $global:AVNDiceDaily_CurrentPlayer += $AVNDiceOffer.$AVNDiceChoiceNumber
            $AVNDiceOffer.remove($AVNDiceChoiceNumber)
            }
            Write-Host "`nYou have selected the following daily dice:" -foregroundcolor $global:AVNDefaultTextForegroundColor
            $global:AVNDiceDaily_CurrentPlayer
        } Else {
            $AVNAllottmentRoll = Get-Random -count $global:AVNDiceChoicePerDay -maximum ($AVNDiceTypes.count) -minimum 1
            $AVNAllottmentRoll | ForEach-Object {
                $global:AVNDiceDaily_CurrentPlayer += $AVNDiceTypes.$_
            }
            Write-Host "`nAs a result of low team health, the following daily dice have been chosen for you:" -foregroundcolor $global:AVNDefaultTextForegroundColor
            $global:AVNDiceDaily_CurrentPlayer
        }
        
        #Getting specials
        #Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
        $AVNDataFileContent | ForEach-Object {
        Invoke-Expression $_
        }

        $AVNInjectionSpecials = @()
        $AVNSpecials | ForEach-Object {
            If ($_.type -eq "injection") {
                $AVNInjectionSpecials += $_
            }
        }

        $AVNInjectionSpecialsAdded = @()
        For ($I = 0; $I -lt $global:AVNInjectionSpecialsPerDay; $I++) {
            $AVNInjectionRewardRoll = Get-Random -minimum 0 -maximum ($AVNInjectionSpecials.count - 1)
            $global:AVNSpecials_CurrentPlayer += $AVNInjectionSpecials[$AVNInjectionRewardRoll].name
            $AVNInjectionSpecialsAdded += $AVNInjectionSpecials[$AVNInjectionRewardRoll].name
        }
        Write-Host "`nThe following injection specials have been added to your collection:" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNInjectionSpecialsAdded

        #Writing back to data file.
        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
        Get-AVNStatus
    } Else {
        Write-Host "`nYou have already signed on once today. Your last Invoke-AVNSignOn on was" $global:AVNPlayerData_CurrentPlayer.lastsignon -foregroundcolor $global:AVNDefaultTextForegroundColor
        Wait-AVNKeyPress
        Get-AVNStatus
    }
}
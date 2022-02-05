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
Function ConvertTo-AVNWriteData {
    param (
        [Parameter()][switch]$System
    )

    If ($False -eq $System) {
        Throw "Do not run this function on its own. Doing so runs the risk of ruining everyone's data files permanently. Plus, it's cheating."
    }
    
    $AVNWriteClientHealth = $global:AVNCompanyData_CurrentPlayer.clienthealth
    $AVNWriteTeamHealth = $global:AVNCompanyData_CurrentPlayer.teamhealth
    $AVNWriteTechnicalQuestionsAdded = $global:AVNCompanyData_CurrentPlayer.technicalquestionsadded
    $AVNWriteTechnicalQuestionsRemoved = $global:AVNCompanyData_CurrentPlayer.technicalquestionsremoved
    $AVNWriteProjectStage1WaveGenerated = $global:AVNCompanyData_CurrentPlayer.ProjectStage1WaveGenerated
    $AVNWriteProjectStage2WaveGenerated = $global:AVNCompanyData_CurrentPlayer.ProjectStage2WaveGenerated
    $AVNWriteProjectStage3WaveGenerated = $global:AVNCompanyData_CurrentPlayer.ProjectStage3WaveGenerated
    $AVNWriteProjectStage1WaveDefeated = $global:AVNCompanyData_CurrentPlayer.ProjectStage1WaveDefeated
    $AVNWriteProjectStage2WaveDefeated = $global:AVNCompanyData_CurrentPlayer.ProjectStage2WaveDefeated
    $AVNWriteProjectStage3WaveDefeated = $global:AVNCompanyData_CurrentPlayer.ProjectStage3WaveDefeated
    #ProjectStage1WaveDefeated = ; ProjectStage2WaveDefeated = ; ProjectStage3WaveDefeated = }
    $AVNWriteKudos = $global:AVNPlayerData_CurrentPlayer.kudos
    $AVNWriteTurns = $global:AVNPlayerData_CurrentPlayer.turns
    $AVNWriteTraining = $global:AVNPlayerData_CurrentPlayer.training
    $AVNWriteLastSignOn = $global:AVNPlayerData_CurrentPlayer.lastsignon
    $AVNWriteOpportunities = $global:AVNPlayerData_CurrentPlayer.opportunities
    If ($False -eq $global:AVNPlayerData_CurrentPlayer.seasonfirstrun) {$AVNWriteSeasonFirstRun = '$False'} Else {$AVNWriteSeasonFirstRun = '$True'}
    $AVNWriteGlobalNotice = $global:AVNPlayerData_CurrentPlayer.globalnotice
    $AVNWriteGifs = $global:AVNPlayerData_CurrentPlayer.gifs
    $AVNWriteProjectStageAttempts = $global:AVNPlayerData_CurrentPlayer.ProjectStageAttempts

    #Creating service tickets array of strings of the date-times then converting that array into a single string.
    $AVNWriteServiceTicketsArray = @()
    If ($global:AVNServiceTickets_CurrentPlayer.count -gt 0) {
        $global:AVNServiceTickets_CurrentPlayer | ForEach-Object {
            $AVNWriteServiceTicketsArray += $_.datetime
        }
        $AVNWriteServiceTickets = $AVNWriteServiceTicketsArray | Join-String -Separator "','" -OutputPrefix "'" -OutputSuffix "'"
    } Else {
        $AVNWriteServiceTickets = ""
    }

    #Dice
    If ($global:AVNDicePerm_CurrentPlayer.count -gt 0) {
        $AVNWriteDicePerm = $global:AVNDicePerm_CurrentPlayer | Join-String -Separator "','" -OutputPrefix "'" -OutputSuffix "'"
    } Else {
        $AVNWriteDicePerm = ""
    }

    If ($global:AVNDiceDaily_CurrentPlayer.count -gt 0) {
        $AVNWriteDiceDaily = $global:AVNDiceDaily_CurrentPlayer | Join-String -Separator "','" -OutputPrefix "'" -OutputSuffix "'"
    } Else {
        $AVNWriteDiceDaily = ""
    }

    #Service ticket specials. Now it's just going to be an array of strings, with the strings being the names of the specials.
    If ($global:AVNSpecials_CurrentPlayer.count -gt 0) {
        $AVNWriteSpecials = $global:AVNSpecials_CurrentPlayer | Join-String -Separator "','" -OutputPrefix "'" -OutputSuffix "'"
    } Else {
        $AVNWriteSpecials = ""
    }

    Return "`$AVNStoredCompanyData = @{ClientHealth = $AVNWriteClientHealth; TeamHealth = $AVNWriteTeamHealth; TechnicalQuestionsAdded = $AVNWriteTechnicalQuestionsAdded; TechnicalQuestionsRemoved = $AVNWriteTechnicalQuestionsRemoved; ProjectStage1WaveGenerated = $AVNWriteProjectStage1WaveGenerated; ProjectStage2WaveGenerated = $AVNWriteProjectStage2WaveGenerated; ProjectStage3WaveGenerated = $AVNWriteProjectStage3WaveGenerated; ProjectStage1WaveDefeated = $AVNWriteProjectStage1WaveDefeated; ProjectStage2WaveDefeated = $AVNWriteProjectStage2WaveDefeated; ProjectStage3WaveDefeated = $AVNWriteProjectStage3WaveDefeated}`n`$AVNStoredPlayerData = @{CurrentUser = '$global:AVNCurrentUser'; PlayerName = '$global:AVNCurrentPlayerName'; Kudos = $AVNWriteKudos; Turns = $AVNWriteTurns; Training = $AVNWriteTraining; LastSignOn = (Get-Date '$AVNWriteLastSignOn').datetime; Opportunities = $AVNWriteOpportunities; SeasonFirstRun = $AVNWriteSeasonFirstRun; GlobalNotice = '$AVNWriteGlobalNotice'; Gifs = $AVNWriteGifs; ProjectStageAttempts = $AVNWriteProjectStageAttempts}`n`$AVNStoredServiceTickets = @($AVNWriteServiceTickets)`n`$AVNStoredDicePerm = @($AVNWriteDicePerm)`n`$AVNStoredDiceDaily = @($AVNWriteDiceDaily)`n`$AVNStoredSpecials = @($AVNWriteSpecials)"
}
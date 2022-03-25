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
    $AVNWriteTeamHealthPenaltyLevel = $global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel
    $AVNWriteClientHealthPenaltyLevel = $global:AVNCompanyData_CurrentPlayer.clienthealthpenaltylevel
    $AVNWriteTechnicalQuestionsAdded = $global:AVNCompanyData_CurrentPlayer.technicalquestionsadded
    $AVNWriteTechnicalQuestionsRemoved = $global:AVNCompanyData_CurrentPlayer.technicalquestionsremoved
    $AVNWriteProjectStage1BlocGenerated = $global:AVNCompanyData_CurrentPlayer.ProjectStage1BlocGenerated
    $AVNWriteProjectStage2BlocGenerated = $global:AVNCompanyData_CurrentPlayer.ProjectStage2BlocGenerated
    $AVNWriteProjectStage3BlocGenerated = $global:AVNCompanyData_CurrentPlayer.ProjectStage3BlocGenerated
    $AVNWriteProjectStage1BlocDefeated = $global:AVNCompanyData_CurrentPlayer.ProjectStage1BlocDefeated
    $AVNWriteProjectStage2BlocDefeated = $global:AVNCompanyData_CurrentPlayer.ProjectStage2BlocDefeated
    $AVNWriteProjectStage3BlocDefeated = $global:AVNCompanyData_CurrentPlayer.ProjectStage3BlocDefeated
    $AVNWriteKudos = $global:AVNPlayerData_CurrentPlayer.kudos
    $AVNWriteTurns = $global:AVNPlayerData_CurrentPlayer.turns
    $AVNWriteTraining = $global:AVNPlayerData_CurrentPlayer.training
    $AVNWriteLastSignOn = $global:AVNPlayerData_CurrentPlayer.lastsignon
    $AVNWriteOpportunities = $global:AVNPlayerData_CurrentPlayer.opportunities
    If ($False -eq $global:AVNPlayerData_CurrentPlayer.seasonfirstrun) {$AVNWriteSeasonFirstRun = '$False'} Else {$AVNWriteSeasonFirstRun = '$True'}
    $AVNWriteGlobalNotice = $global:AVNPlayerData_CurrentPlayer.globalnotice
    $AVNWriteGifs = $global:AVNPlayerData_CurrentPlayer.gifs
    $AVNWriteProjectBlocAttempts = $global:AVNPlayerData_CurrentPlayer.ProjectBlocAttempts
    #Historical data
    $AVNWriteHistRecentClient = $global:AVNHistoricalData_CurrentPlayer.RecentClientHealthContributions
    $AVNWriteHistTotalClient = $global:AVNHistoricalData_CurrentPlayer.TotalClientHealthContributions
    $AVNWriteHistRecentTeam = $global:AVNHistoricalData_CurrentPlayer.RecentTeamHealthContributions
    $AVNWriteHistTotalTeam = $global:AVNHistoricalData_CurrentPlayer.TotalTeamHealthContributions
    $AVNWriteHistRecentProjectBlocs = $global:AVNHistoricalData_CurrentPlayer.RecentProjectStageBlocsCompleted
    $AVNWriteHistTotalProjectBlocs = $global:AVNHistoricalData_CurrentPlayer.TotalProjectStageBlocsCompleted
    $AVNWriteHistRecentKudos = $global:AVNHistoricalData_CurrentPlayer.RecentKudos
    $AVNWriteHistTotalKudos = $global:AVNHistoricalData_CurrentPlayer.TotalKudos
    $AVNWriteHistRecentGIFs = $global:AVNHistoricalData_CurrentPlayer.RecentGIFs
    $AVNWriteHistTotalGIFs = $global:AVNHistoricalData_CurrentPlayer.TotalGIFs


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

    Return "`$AVNStoredCompanyData = @{ClientHealth = $AVNWriteClientHealth; TeamHealth = $AVNWriteTeamHealth; TeamHealthPenaltyLevel = $AVNWriteTeamHealthPenaltyLevel; ClientHealthPenaltyLevel = $AVNWriteClientHealthPenaltyLevel; TechnicalQuestionsAdded = $AVNWriteTechnicalQuestionsAdded; TechnicalQuestionsRemoved = $AVNWriteTechnicalQuestionsRemoved; ProjectStage1BlocGenerated = $AVNWriteProjectStage1BlocGenerated; ProjectStage2BlocGenerated = $AVNWriteProjectStage2BlocGenerated; ProjectStage3BlocGenerated = $AVNWriteProjectStage3BlocGenerated; ProjectStage1BlocDefeated = $AVNWriteProjectStage1BlocDefeated; ProjectStage2BlocDefeated = $AVNWriteProjectStage2BlocDefeated; ProjectStage3BlocDefeated = $AVNWriteProjectStage3BlocDefeated}`n`$AVNStoredPlayerData = @{CurrentUser = '$global:AVNCurrentUser'; PlayerName = '$global:AVNCurrentPlayerName'; Kudos = $AVNWriteKudos; Turns = $AVNWriteTurns; Training = $AVNWriteTraining; LastSignOn = (Get-Date '$AVNWriteLastSignOn').datetime; Opportunities = $AVNWriteOpportunities; SeasonFirstRun = $AVNWriteSeasonFirstRun; GlobalNotice = '$AVNWriteGlobalNotice'; Gifs = $AVNWriteGifs; ProjectBlocAttempts = $AVNWriteProjectBlocAttempts}`n`$AVNStoredServiceTickets = @($AVNWriteServiceTickets)`n`$AVNStoredDicePerm = @($AVNWriteDicePerm)`n`$AVNStoredDiceDaily = @($AVNWriteDiceDaily)`n`$AVNStoredSpecials = @($AVNWriteSpecials)`n`$AVNStoredHistoricalData = @{RecentClientHealthContributions = $AVNWriteHistRecentClient; TotalClientHealthContributions = $AVNWriteHistTotalClient; RecentTeamHealthContributions = $AVNWriteHistRecentTeam; TotalTeamHealthContributions = $AVNWriteHistTotalTeam; RecentProjectStageBlocsCompleted = $AVNWriteHistRecentProjectBlocs; TotalProjectStageBlocsCompleted = $AVNWriteHistTotalProjectBlocs; RecentKudos = $AVNWriteHistRecentKudos; TotalKudos = $AVNWriteHistTotalKudos; RecentGIFs = $AVNWriteHistRecentGIFs; TotalGIFs = $AVNWriteHistTotalGIFs}"
}
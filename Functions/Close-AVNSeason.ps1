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
Function Close-AVNSeason {
    #Making sure the user knows what he's doing.
    Write-Host "Running this function converts all players' current data into historical data and resets the season." -foregroundcolor "darkred"
    $AVNCheck = Read-Host "To continue, please enter 'resetcurrentdata' without the quotes (enter anything else to exit the function)"
    If ($AVNCheck -ne "resetcurrentdata") {
        Return
    }

    $AVNDataFiles = Get-ChildItem -file -path ($global:AVNRootPath + '\data')

    ForEach ($AVNDataFile in $AVNDataFiles) {
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path $AVNDataFile
        $AVNDataFileContent | ForEach-Object {
        Invoke-Expression $_
        }

        #Create all pertinent global current variables from stored variables
        $global:AVNPlayerData_CurrentPlayer = $AVNStoredPlayerData
        $global:AVNCompanyData_CurrentPlayer = $AVNStoredCompanyData
        $global:AVNHistoricalData_CurrentPlayer = $AVNStoredHistoricalData
        
        #Updating all historical data
        $global:AVNHistoricalData_CurrentPlayer.RecentClientHealthContributions = $global:AVNCompanyData_CurrentPlayer.clienthealth
        $global:AVNHistoricalData_CurrentPlayer.TotalClientHealthContributions += $global:AVNCompanyData_CurrentPlayer.clienthealth
        $global:AVNHistoricalData_CurrentPlayer.RecentTeamHealthContributions = $global:AVNCompanyData_CurrentPlayer.teamhealth
        $global:AVNHistoricalData_CurrentPlayer.TotalTeamHealthContributions += $global:AVNCompanyData_CurrentPlayer.teamhealth
        $AVNTotalProjectStageBlocsCompleted = $global:AVNCompanyData_CurrentPlayer.ProjectStage1BlocDefeated + $global:AVNCompanyData_CurrentPlayer.ProjectStage2BlocDefeated + $global:AVNCompanyData_CurrentPlayer.ProjectStage3BlocDefeated
        $global:AVNHistoricalData_CurrentPlayer.RecentProjectStageBlocsCompleted = $AVNTotalProjectStageBlocsCompleted
        $global:AVNHistoricalData_CurrentPlayer.TotalProjectStageBlocsCompleted += $AVNTotalProjectStageBlocsCompleted
        $global:AVNHistoricalData_CurrentPlayer.RecentKudos = $global:AVNPlayerData_CurrentPlayer.kudos
        $global:AVNHistoricalData_CurrentPlayer.TotalKudos += $global:AVNPlayerData_CurrentPlayer.kudos
        $global:AVNHistoricalData_CurrentPlayer.RecentGIFs = $global:AVNPlayerData_CurrentPlayer.gifs
        $global:AVNHistoricalData_CurrentPlayer.TotalGifs += $global:AVNPlayerData_CurrentPlayer.gifs

        #Resetting current data
        $global:AVNCompanyData_CurrentPlayer = @{
            ClientHealth = 0
            TeamHealth = 0
            TechnicalQuestionsAdded = 0 
            TechnicalQuestionsRemoved = 0
            ProjectStage1BlocGenerated = 0
            ProjectStage2BlocGenerated = 0
            ProjectStage3BlocGenerated = 0
            ProjectStage1BlocDefeated = 0
            ProjectStage2BlocDefeated = 0
            ProjectStage3BlocDefeated = 0
        }

        #Not changing player name or current user --allow players to change their own names?
        $AVNDateTimePlaceHolder = (Get-Date).AddHours(-25)
        $global:AVNPlayerData_CurrentPlayer.kudos = 0
        $global:AVNPlayerData_CurrentPlayer.turns = 0
        $global:AVNPlayerData_CurrentPlayer.training = 0
        $global:AVNPlayerData_CurrentPlayer.lastsignon = $AVNDateTimePlaceHolder
        $global:AVNPlayerData_CurrentPlayer.opportunities = 0
        $global:AVNPlayerData_CurrentPlayer.seasonfirstrun = $True
        $global:AVNPlayerData_CurrentPlayer.globalnotice = ''
        $global:AVNPlayerData_CurrentPlayer.gifs = 0
        $global:AVNPlayerData_CurrentPlayer.projectstageattempts = 0

        $global:AVNServiceTickets_CurrentPlayer = @()
        $global:AVNDicePerm_CurrentPlayer = @('CoreValues','ITGlue')
        $global:AVNDiceDaily_CurrentPlayer = @()
        $global:AVNSpecials_CurrentPlayer = @()

        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $AVNDataFile
    }
}
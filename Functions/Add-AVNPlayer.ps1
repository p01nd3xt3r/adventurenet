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
Function Add-AVNPlayer {
    param (
        [Parameter()][switch]$System
    )

    If ($False -eq $System) {
        Throw "Do not run this function on its own. Doing so runs the risk of ruining everyone's data files permanently. Plus, it's cheating."
    }

    #Since this will be run from the get-avnconfig function, I'm not calling it again here. All the global variables should be up to date. Just need to make sure it has all the local ones it had before I separated this to a function.
    If ($global:AVNCompanyDataCommon.ProjectStage1Complete -eq $True) {
        Throw "Sorry, you're too late! This season has advanced too far for you to join. Please wait until next season."
    }
    $global:AVNCurrentPlayerName = ""
    
    #New because I changed the array from a simple hash table to an array of arrays
    $AVNCurrentPlayerNameTaken = $False
    While (($global:AVNCurrentPlayerName -eq "") -or ($True -eq $AVNCurrentPlayerNameTaken)) {
        $global:AVNCurrentPlayerName = Read-Host -prompt "Please choose a player name"
        $global:AVNPlayerDataCommon | ForEach-Object {
            If ($global:AVNCurrentPlayerName -in $_) {
                $AVNCurrentPlayerNameTaken = $True
            }
        }
        If ($True -eq $AVNCurrentPlayerNameTaken) {
            Write-Host $global:AVNCurrentPlayerName" has already been taken. Please try another." -foregroundcolor $global:AVNDefaultTextForegroundColor
        }
    }

    #When creating a file, this will create a random string for naming it, if I am obfuscating. It just gets random of a couple of number range arrays and then converts it into a char.
    If ($True -eq $AVNObfuscate) {
        $AVNFileName = -join ((65..90) + (97..122) | Get-Random -Count 12 | Foreach-Object {[char]$_})
    } Else {
        #Currently just the same as the above because my player names have domain\ in them, which will not work for filenames.
        #$AVNFileName = $global:AVNCurrentPlayerName
        $AVNFileName = -join ((65..90) + (97..122) | Get-Random -Count 12 | Foreach-Object {[char]$_})
    }
    #Getting the fullname of the file and creating it at the same time using the above name.
    $global:AVNCurrentPlayerDataFile = (New-Item -path ($global:AVNRootPath + '\data') -name $AVNFileName -itemtype "file").fullname

    #Initializing data as if from stored.
    $AVNStoredCompanyData = @{
        ClientHealth = 0
        TeamHealth = 0
        TechnicalQuestionsAdded = 0
        TechnicalQuestionsRemoved = 0
        ProjectStage1WaveGenerated = 0
        ProjectStage2WaveGenerated = 0
        ProjectStage3WaveGenerated = 0
        ProjectStage1WaveDefeated = 0
        ProjectStage2WaveDefeated = 0
        ProjectStage3WaveDefeated = 0
    }
    $AVNDateTimePlaceHolder = (Get-Date).AddHours(-25)
    $AVNStoredPlayerData = @{
        CurrentUser = $global:AVNCurrentUser
        PlayerName = $global:AVNCurrentPlayerName
        Kudos = 0
        Turns = 0
        Training = 0
        LastSignOn = $AVNDateTimePlaceHolder
        Opportunities = 0
        SeasonFirstRun = $True
        GlobalNotice = ""
        Gifs = 0
        ProjectStageAttempts = 0
    }
    $AVNStoredHistoricalData = @{
        RecentClientHealthContributions = 0
        TotalClientHealthContributions = 0
        RecentTeamHealthContributions = 0
        TotalTeamHealthContributions = 0
        RecentProjectStageWavesCompleted = 0
        TotalProjectStageWavesCompleted = 0
        RecentKudos = 0
        TotalKudos = 0
        RecentGIFs = 0 
        TotalGifs = 0
    }

    #Assigning new player's stored-emulated player data to the working global variables so that they can be written back to his data file. I could have just created the global variables directly. But I didn't.
    $global:AVNPlayerData_CurrentPlayer = $AVNStoredPlayerData
    $global:AVNHistoricalData_CurrentPlayer = $AVNStoredHistoricalData
    $global:AVNPlayerDataCommon += @($AVNStoredPlayerData.playername, $AVNStoredPlayerData.kudos, $AVNStoredPlayerData.globalnotice)
    #Assigning all company data as well.
    $global:AVNCompanyData_CurrentPlayer.clienthealth = $AVNStoredCompanyData.clienthealth
    $global:AVNCompanyData_CurrentPlayer.teamhealth = $AVNStoredCompanyData.teamhealth
    $global:AVNCompanyData_CurrentPlayer.ProjectStage1WaveGenerated = $AVNStoredCompanyData.ProjectStage1WaveGenerated
    $global:AVNCompanyData_CurrentPlayer.ProjectStage2WaveGenerated = $AVNStoredCompanyData.ProjectStage2WaveGenerated
    $global:AVNCompanyData_CurrentPlayer.ProjectStage3WaveGenerated = $AVNStoredCompanyData.ProjectStage3WaveGenerated
    $global:AVNCompanyData_CurrentPlayer.ProjectStage1WaveDefeated = $AVNStoredCompanyData.ProjectStage1WaveDefeated
    $global:AVNCompanyData_CurrentPlayer.ProjectStage2WaveDefeated = $AVNStoredCompanyData.ProjectStage2WaveDefeated
    $global:AVNCompanyData_CurrentPlayer.ProjectStage3WaveDefeated = $AVNStoredCompanyData.ProjectStage3WaveDefeated

    #Assigning service tickets.
    $global:AVNServiceTickets_CurrentPlayer = @()
    
    $global:AVNDicePerm_CurrentPlayer = @('CoreValues','ITGlue')
    $global:AVNDiceDaily_CurrentPlayer = @()
    $global:AVNSpecials_CurrentPlayer = @()

    
    If ($AVNStoredCompanyData.ProjectStage1WaveGenerated -gt 0) {
        $global:AVNCompanyDataCommon.ProjectWavesGenerated = $True
    }

    #Does this go here? Do I need get-config after it? Do I only need it for new player data files and not in signon? 
    Add-AVNProjectWaves -system

    ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
}
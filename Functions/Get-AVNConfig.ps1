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
Function Get-AVNConfig {
    <#
    Not sure this parameter is needed anymore.
    param (
        [Parameter(helpmessage='Forces the config to run again even if the $AVNVariable already exists.')][switch]$Force
    )
    #>

    #Quick check to make sure this function is running from the imported module. Also creating root folder path variable at the same time. 
    $global:AVNRootPath = (Get-Module "AdventureNet").ModuleBase.tostring()
    If (!(Test-Path $global:AVNRootPath)) {
            Throw "You don't seem to be running this function from an imported AdventureNet Module."
    }

    #Getting config file and content. I switched to just having it all in variable assignment format in the config file.
    $AVNConfigContentPath = $global:AVNRootPath + '\AdventureNet.config'
    If (!(Test-Path $AVNConfigContentPath)) {
        Throw "You're running this function from an unexpected location, or else your AdventureNet.config file has been misplaced."
    }
    $AVNConfigContent = Get-Content $AVNConfigContentPath
    $AVNConfigContent | ForEach-Object {
        Invoke-Expression $_
    }

    #Warning if running the module from some non-standard location.
    If ($global:AVNRootPath -ne $global:AVNProductionPath) {
        Write-Host "Note that you are not running this module from the assigned production path." -foregroundcolor "darkred"
    }
    
    #Getting current username.
    $global:AVNCurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

    #Initializing these just to have them for later on. They get their data from the player's data file. They're not globals but are used to populate the globals, $global:AVNCompanyData and $global:AVNPlayerData. Might remove these from here later.
    $AVNStoredCompanyData = @{}
    $AVNStoredPlayerData = @{}

    #Initializing these for below.
    $global:AVNPlayerDataCommon = @()
    $global:AVNCompanyDataCommon = @{
        #If I set these at 25 and let players either add or remove, I should have benefits for it being higher than 25. Possibly. But this will set them for player's lowering them into penalty criteria.
        ClientHealth = 25
        TeamHealth = 25
        #This technicalquestions is used for determinging how many there are minus the player's own. The player shouldn't be able to answer his own technical questions. It comes from the _added and _removed keys in the player's company data hash.
        TechnicalQuestionsAvailable = 0
        TechnicalQuestionsTotal = 0
        ProjectWavesGenerated = $False
        ProjectStage1WavesRemaining = 0
        ProjectStage2WavesRemaining = 0
        ProjectStage3WavesRemaining = 0
        ProjectStage1Complete = $False
        SeasonComplete = $False
        CurrentStage = 1
    }
        
    $global:AVNServiceTickets_CurrentPlayer = @()
    #These are just for writing back to the player's data file.
    $global:AVNCompanyData_CurrentPlayer = @{
        ClientHealth = 0
        TeamHealth = 0
        TechnicalQuestionsAdded = 0
        TechnicalQuestionsRemoved = 0
    }

    #Getting \data files and content.
    #Because I'm checking for the filename for the current user every time, I'm initiating the variable as Global and $Null here.
    $global:AVNCurrentPlayerDataFile = $Null
    #Getting all data files and looping through their contents, adding all company data to a pool and creating separate variables for appropriate hash tables. I'm only keeping the data file name of the current user because I shouldn't be writing to the other players' files anyways.
    If (!(Test-Path -pathtype "container" -path ($global:AVNRootPath + '\data'))) {
        New-Item -path ($global:AVNRootPath + '\data') -itemtype "directory"
    }
    $AVNDataFiles = Get-ChildItem -path ($global:AVNRootPath + '\data')
    $AVNDataFiles | ForEach-Object {
        #Getting content from the current data file and invoking each line of it. Each line is its own variable declaration.
        $AVNCurrentDataFileContent = ConvertFrom-AVNObfuscated -path $_
        $AVNCurrentDataFileContent | ForEach-Object {
            #$AVNStoredPlayerData and $AVNStoredCompanyData are in here.
            Invoke-Expression $_
        }
        #Finding current username, seeing if the data file belongs to that user, and assigning it to the user. Also applying the player name to the user, which can be used to find the right player and company data variables later. Also adding player and company data to currentuser variables.
        
        If ($AVNStoredPlayerData.CurrentUser -eq $global:AVNCurrentUser) {
            #Assigning the filename and path currently being addressed to this variable.
            $global:AVNCurrentPlayerDataFile = $_.fullname
            $global:AVNCurrentPlayerName = $AVNStoredPlayerData.playername
            #Assigning new player's player data to variables.
            $global:AVNPlayerData_CurrentPlayer = $AVNStoredPlayerData
            $global:AVNCompanyData_CurrentPlayer = $AVNStoredCompanyData
            $global:AVNPlayerDataCommon += @($AVNStoredPlayerData.playername, $AVNStoredPlayerData.kudos, $AVNStoredPlayerData.globalnotice)
            #Assigning all company data as well. 
            $global:AVNCompanyDataCommon.clienthealth += $AVNStoredCompanyData.clienthealth
            $global:AVNCompanyDataCommon.teamhealth += $AVNStoredCompanyData.teamhealth
            $global:AVNCompanyDataCommon.technicalquestionsavailable -= $AVNStoredCompanyData.technicalquestionsremoved
            $global:AVNCompanyDataCommon.technicalquestionstotal -= $AVNStoredCompanyData.technicalquestionsremoved
            $global:AVNCompanyDataCommon.technicalquestionstotal += $AVNStoredCompanyData.technicalquestionsadded
            If ($AVNStoredCompanyData.ProjectStage1WaveGenerated -gt 0) {
                $global:AVNCompanyDataCommon.ProjectWavesGenerated = $True
            }
            #Remaining doesn't take into account whether or not a player has completed a wave, unlike technical questions.
            $global:AVNCompanyDataCommon.ProjectStage1WavesRemaining += $AVNStoredCompanyData.ProjectStage1WaveGenerated
            $global:AVNCompanyDataCommon.ProjectStage1WavesRemaining -= $AVNStoredCompanyData.ProjectStage1WaveDefeated
            $global:AVNCompanyDataCommon.ProjectStage2WavesRemaining += $AVNStoredCompanyData.ProjectStage2WaveGenerated
            $global:AVNCompanyDataCommon.ProjectStage2WavesRemaining -= $AVNStoredCompanyData.ProjectStage2WaveDefeated
            $global:AVNCompanyDataCommon.ProjectStage3WavesRemaining += $AVNStoredCompanyData.ProjectStage3WaveGenerated
            $global:AVNCompanyDataCommon.ProjectStage3WavesRemaining -= $AVNStoredCompanyData.ProjectStage3WaveDefeated
            
            #Assigning service tickets.
            If ($AVNStoredServiceTickets.count -gt 0) {
                $AVNStoredServiceTickets | ForEach-Object {
                    $AVNStoredDateTime = Get-Date $_
                    $global:AVNServiceTickets_CurrentPlayer += $AVNStoredDateTime
                }
            } Else {
                $global:AVNServiceTickets_CurrentPlayer = @()
            }
            #Dice of the current player.
            $global:AVNDicePerm_CurrentPlayer = $AVNStoredDicePerm
            $global:AVNDiceDaily_CurrentPlayer = $AVNStoredDiceDaily
            #Service ticket specials of the current player
            $global:AVNSpecials_CurrentPlayer = $AVNStoredSpecials
        } Else {
            #Assigning all other player data to variables with their player names in them.
            $global:AVNPlayerDataCommon += @($AVNStoredPlayerData.playername, $AVNStoredPlayerData.kudos, $AVNStoredPlayerData.globalnotice)
            $global:AVNCompanyDataCommon.clienthealth += $AVNStoredCompanyData.clienthealth
            $global:AVNCompanyDataCommon.teamhealth += $AVNStoredCompanyData.teamhealth
            $global:AVNCompanyDataCommon.technicalquestionsavailable += $AVNStoredCompanyData.technicalquestionsadded
            $global:AVNCompanyDataCommon.technicalquestionsavailable -= $AVNStoredCompanyData.technicalquestionsremoved
            $global:AVNCompanyDataCommon.technicalquestionstotal += $AVNStoredCompanyData.technicalquestionsadded
            $global:AVNCompanyDataCommon.technicalquestionstotal -= $AVNStoredCompanyData.technicalquestionsremoved
            If ($AVNStoredCompanyData.ProjectStage1WaveGenerated -gt 0) {
                $global:AVNCompanyDataCommon.ProjectWavesGenerated = $True
            }
            #Remaining doesn't take into account whether or not a player has completed a wave, unlike technical questions.
            $global:AVNCompanyDataCommon.ProjectStage1WavesRemaining += $AVNStoredCompanyData.ProjectStage1WaveGenerated
            $global:AVNCompanyDataCommon.ProjectStage1WavesRemaining -= $AVNStoredCompanyData.ProjectStage1WaveDefeated
            $global:AVNCompanyDataCommon.ProjectStage2WavesRemaining += $AVNStoredCompanyData.ProjectStage2WaveGenerated
            $global:AVNCompanyDataCommon.ProjectStage2WavesRemaining -= $AVNStoredCompanyData.ProjectStage2WaveDefeated
            $global:AVNCompanyDataCommon.ProjectStage3WavesRemaining += $AVNStoredCompanyData.ProjectStage3WaveGenerated
            $global:AVNCompanyDataCommon.ProjectStage3WavesRemaining -= $AVNStoredCompanyData.ProjectStage3WaveDefeated
        }
    }

    #If it's gone through all the files and hasn't found a .currentuser that matches the current user, this variable will remain $Null from above, and this'll initialize a new file and the variables that file would have initialized. 
    If ($Null -eq $global:AVNCurrentPlayerDataFile) {
        Add-AVNPlayer -system
    }

    #Determining current stage (for determining things like what encounters are available) and if stage1 or the whole season has been completed. The seasoncomplete hash is used in invoke-avnsignon to throw an error if $true, and the projectstage1complete hash is used in add-avnnewplayer to throw an error if true.

    If (($True -eq $global:AVNCompanyDataCommon.ProjectWavesGenerated) -and ($global:AVNCompanyDataCommon.ProjectStage3WavesRemaining -lt 1)) {
        $global:AVNCompanyDataCommon.ProjectStage1Complete = $True
        $global:AVNCompanyDataCommon.CurrentStage = 3
        $global:AVNCompanyDataCommon.SeasonComplete = $True
    } ElseIf (($True -eq $global:AVNCompanyDataCommon.ProjectWavesGenerated) -and ($global:AVNCompanyDataCommon.ProjectStage2WavesRemaining -lt 1)) {
        $global:AVNCompanyDataCommon.ProjectStage1Complete = $True
        $global:AVNCompanyDataCommon.CurrentStage = 3
    } ElseIf (($True -eq $global:AVNCompanyDataCommon.ProjectWavesGenerated) -and ($global:AVNCompanyDataCommon.ProjectStage1WavesRemaining -lt 1)) {
        $global:AVNCompanyDataCommon.ProjectStage1Complete = $True
        $global:AVNCompanyDataCommon.CurrentStage = 2
    }
}

    #For each change to getting data from data files, note that there's one section for the current player that has a file, one for all the rest of the players, and one for the current player that doesn't have a file.
    
    <#
    Adding project waves based on the $global:AVNProjectWaveGenerationRate from the config file. See if this is the first run of the season. Need a new variable in the player hash. Needs to be for each current player--both new and old. Adding a new variable to check for it being an old season or not. I am thinking of whether or not to do a FirstRun = $True in the player hash. But where do I check and then run this? Should I have a function for starting a season and then call it from sign on? Does it go in config? What other things need to happen at the start of a season? I do this in add-avnprojectwaves now. I have the seasonfirstrun hash changing to false there when it runs, and there's a 100% chance of creating all three waves for the first player that creates waves for the season. The getconfg function changes the projectwavesgenerated hash in the common hash that's used to determine if this has been done yet.

    To handle seasons, I created the close-avnseason function and need to design it. That way I'm not checking for things like what season it is every get-avnconfig. I'll just have it so that players can't do anything if all waves have been completed (and the season is over). I need to do a start-season function as well that wraps up all data files and resets get-date and the seasonfirstrun flag in the players' data files. Of course maybe the seasonclose function will do all this, and there doesn't need to be a seasonstart function at all.

    How to arrange project data:
    Likewise, in the common hash I will have to track remaining waves and remaining stages based on the generated and defeated fields in the players' company data hash. These will be used to determine whether or not a player can attack a wave and what level of service ticket to face and if it's the end of the season or not.

    What about project stage deadlines? Are those set in the config file? They'd have to be.

    Could I allow players to share dice with others? Perhaps it's a special?
#>
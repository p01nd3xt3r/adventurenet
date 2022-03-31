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
    
    #Getting current username.
    $global:AVNCurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

    #Initializing these just to have them for later on. They get their data from the player's data file. They're not globals but are used to populate the globals, $global:AVNCompanyData and $global:AVNPlayerData. Might remove these from here later.
    $AVNStoredCompanyData = @{}
    $AVNStoredPlayerData = @{}

    #Initializing these for below.
    $global:AVNPlayerDataCommon = @()
    $global:AVNCompanyDataCommon = @{
        #If I set these at 25 and let players either add or remove, I should have benefits for it being higher than 25. Possibly. But this will set them for player's lowering them into penalty criteria.
        ClientHealth = $global:AVNHealthDefault
        TeamHealth = $global:AVNHealthDefault
        #This technicalquestions is used for determinging how many there are minus the player's own. The player shouldn't be able to answer his own technical questions. It comes from the _added and _removed keys in the player's company data hash.
        TechnicalQuestionsAvailable = 0
        TechnicalQuestionsTotal = 0
        ProjectBlocsGenerated = $False
        ProjectStage1BlocsRemaining = 0
        ProjectStage2BlocsRemaining = 0
        ProjectStage3BlocsRemaining = 0
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
    
    #Goes with checking last sign on at the beginning of this next loop.
    $global:AVNMostRecentSignOn = (Get-Date).addyears(-100)

    $AVNDataFiles | ForEach-Object {
        #Getting content from the current data file and invoking each line of it. Each line is its own variable declaration.
        $AVNCurrentDataFileContent = ConvertFrom-AVNObfuscated -path $_.fullname
        $AVNCurrentDataFileContent | ForEach-Object {
            Invoke-Expression $_
        }

        #For balancing penalties in conjunction with Invoke-AVNSignOn; runs for every data file so precedes the fork below. $global:AVNMostRecentSignOn is initialized above this ForEach-Object.
        If ((Get-Date $AVNStoredPlayerData.LastSignOn) -gt ($global:AVNMostRecentSignOn)) {
            $global:AVNMostRecentSignOn = (Get-Date $AVNStoredPlayerData.LastSignOn)
            #$global:AVNMostRecentTeamHealthPenaltyLevel = $global:AVNCompanyData_CurrentPlayer.teamhealthpenaltylevel
            $global:AVNMostRecentTeamHealthPenaltyLevel = $AVNStoredCompanyData.teamhealthpenaltylevel
            #$global:AVNMostRecentClientHealthPenaltyLevel = $global:AVNCompanyData_CurrentPlayer.clienthealthpenaltylevel
            $global:AVNMostRecentClientHealthPenaltyLevel = $AVNStoredCompanyData.clienthealthpenaltylevel
        }
        
        #Finding current username, seeing if the data file belongs to that user, and assigning it to the user. Also applying the player name to the user, which can be used to find the right player and company data variables later. Also adding player and company data to currentuser variables.
        If ($AVNStoredPlayerData.CurrentUser -eq $global:AVNCurrentUser) {
            #Assigning the filename and path currently being addressed to this variable.
            $global:AVNCurrentPlayerDataFile = $_.fullname
            $global:AVNCurrentPlayerName = $AVNStoredPlayerData.playername
            #Assigning new player's player data to variables.
            $global:AVNPlayerData_CurrentPlayer = $AVNStoredPlayerData
            $global:AVNCompanyData_CurrentPlayer = $AVNStoredCompanyData
            #Will add some parts of this to the common variable at some point so players can see it all.
            $global:AVNHistoricalData_CurrentPlayer = $AVNStoredHistoricalData
            $global:AVNPlayerDataCommon += @{PlayerName = $AVNStoredPlayerData.playername; Kudos = $AVNStoredPlayerData.kudos; GlobalNotice = $AVNStoredPlayerData.globalnotice}
            #Assigning all company data as well. 
            $global:AVNCompanyDataCommon.clienthealth += $AVNStoredCompanyData.clienthealth
            $global:AVNCompanyDataCommon.teamhealth += $AVNStoredCompanyData.teamhealth
            $global:AVNCompanyDataCommon.technicalquestionsavailable -= $AVNStoredCompanyData.technicalquestionsremoved
            $global:AVNCompanyDataCommon.technicalquestionstotal -= $AVNStoredCompanyData.technicalquestionsremoved
            $global:AVNCompanyDataCommon.technicalquestionstotal += $AVNStoredCompanyData.technicalquestionsadded
            If ($AVNStoredCompanyData.ProjectStage1BlocGenerated -gt 0) {
                $global:AVNCompanyDataCommon.ProjectBlocsGenerated = $True
            }
            #Remaining doesn't take into account whether or not a player has completed a Bloc, unlike technical questions.
            $global:AVNCompanyDataCommon.ProjectStage1BlocsRemaining += $AVNStoredCompanyData.ProjectStage1BlocGenerated
            $global:AVNCompanyDataCommon.ProjectStage1BlocsRemaining -= $AVNStoredCompanyData.ProjectStage1BlocDefeated
            $global:AVNCompanyDataCommon.ProjectStage2BlocsRemaining += $AVNStoredCompanyData.ProjectStage2BlocGenerated
            $global:AVNCompanyDataCommon.ProjectStage2BlocsRemaining -= $AVNStoredCompanyData.ProjectStage2BlocDefeated
            $global:AVNCompanyDataCommon.ProjectStage3BlocsRemaining += $AVNStoredCompanyData.ProjectStage3BlocGenerated
            $global:AVNCompanyDataCommon.ProjectStage3BlocsRemaining -= $AVNStoredCompanyData.ProjectStage3BlocDefeated
            
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
            $global:AVNDicePerm_CurrentPlayer = $AVNStoredDicePerm | Sort-Object
            $global:AVNDiceDaily_CurrentPlayer = $AVNStoredDiceDaily | Sort-Object
            #Service ticket specials of the current player
            $global:AVNSpecials_CurrentPlayer = $AVNStoredSpecials | Sort-Object
        } Else {
            #Assigning all other player data to variables with their player names in them.
            $global:AVNPlayerDataCommon += @{PlayerName = $AVNStoredPlayerData.playername; Kudos = $AVNStoredPlayerData.kudos; GlobalNotice = $AVNStoredPlayerData.globalnotice}
            $global:AVNCompanyDataCommon.clienthealth += $AVNStoredCompanyData.clienthealth
            $global:AVNCompanyDataCommon.teamhealth += $AVNStoredCompanyData.teamhealth
            $global:AVNCompanyDataCommon.technicalquestionsavailable += $AVNStoredCompanyData.technicalquestionsadded
            $global:AVNCompanyDataCommon.technicalquestionsavailable -= $AVNStoredCompanyData.technicalquestionsremoved
            $global:AVNCompanyDataCommon.technicalquestionstotal += $AVNStoredCompanyData.technicalquestionsadded
            $global:AVNCompanyDataCommon.technicalquestionstotal -= $AVNStoredCompanyData.technicalquestionsremoved
            If ($AVNStoredCompanyData.ProjectStage1BlocGenerated -gt 0) {
                $global:AVNCompanyDataCommon.ProjectBlocsGenerated = $True
            }
            #Remaining doesn't take into account whether or not a player has completed a Bloc, unlike technical questions.
            $global:AVNCompanyDataCommon.ProjectStage1BlocsRemaining += $AVNStoredCompanyData.ProjectStage1BlocGenerated
            $global:AVNCompanyDataCommon.ProjectStage1BlocsRemaining -= $AVNStoredCompanyData.ProjectStage1BlocDefeated
            $global:AVNCompanyDataCommon.ProjectStage2BlocsRemaining += $AVNStoredCompanyData.ProjectStage2BlocGenerated
            $global:AVNCompanyDataCommon.ProjectStage2BlocsRemaining -= $AVNStoredCompanyData.ProjectStage2BlocDefeated
            $global:AVNCompanyDataCommon.ProjectStage3BlocsRemaining += $AVNStoredCompanyData.ProjectStage3BlocGenerated
            $global:AVNCompanyDataCommon.ProjectStage3BlocsRemaining -= $AVNStoredCompanyData.ProjectStage3BlocDefeated
        }
    }

    #If it's gone through all the files and hasn't found a .currentuser that matches the current user, this variable will remain $Null from above, and this'll initialize a new file and the variables that file would have initialized. 
    If ($Null -eq $global:AVNCurrentPlayerDataFile) {
        Add-AVNPlayer -system
    }

    #Determining current stage (for determining things like what encounters are available) and if stage1 or the whole season has been completed. The seasoncomplete hash is used in invoke-avnsignon to throw an error if $true, and the projectstage1complete hash is used in add-avnnewplayer to throw an error if true.

    If (($True -eq $global:AVNCompanyDataCommon.ProjectBlocsGenerated) -and ($global:AVNCompanyDataCommon.ProjectStage3BlocsRemaining -lt 1)) {
        $global:AVNCompanyDataCommon.ProjectStage1Complete = $True
        $global:AVNCompanyDataCommon.CurrentStage = 3
        $global:AVNCompanyDataCommon.SeasonComplete = $True
    } ElseIf (($True -eq $global:AVNCompanyDataCommon.ProjectBlocsGenerated) -and ($global:AVNCompanyDataCommon.ProjectStage2BlocsRemaining -lt 1)) {
        $global:AVNCompanyDataCommon.ProjectStage1Complete = $True
        $global:AVNCompanyDataCommon.CurrentStage = 3
    } ElseIf (($True -eq $global:AVNCompanyDataCommon.ProjectBlocsGenerated) -and ($global:AVNCompanyDataCommon.ProjectStage1BlocsRemaining -lt 1)) {
        $global:AVNCompanyDataCommon.ProjectStage1Complete = $True
        $global:AVNCompanyDataCommon.CurrentStage = 2
    }
}
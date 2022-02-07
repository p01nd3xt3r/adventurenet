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
Function ConvertTo-AVNDevWriteData {
    param (
        [Parameter()][switch]$System
    )

    If ($False -eq $System) {
        Throw "Do not run this function on its own. Doing so runs the risk of ruining everyone's data files permanently. Plus, it's cheating."
    }
    <#
    Specifically for sending data into the different encounter data files, since they are so leathery. Should be kept out of the production directory.
    Eventually this will be used for that, if I still need it. For the time being, I'll just build all the hashtables here, since it'll be a much easier format to read. I can call the function to add all the variables.

    Template = @{
            Name = ""
            ReqProjectStage = 0
            Wave1 = 0
            Wave2 = 0
            Wave3 = 0
            DefWorkstation = $False
            DefCloud = $False
            DefOnPrem = $False
            DefNetworking = $False
            DefSecurity = $False
            DefCharacter = $True
            IntroductionText = ""
            FailureText = ""
            FailurePenalty = ""
            WaveSuccessText = ""
            DeathText = ""
            Opportunity = $False
        }

        DO NOT USE APOSTROPHES. It'll mess up writing data.
    #>
    $global:AVNServiceTicketEncounters = @(
        @{
            Name = "Haggard Workhorse"
            ReqProjectStage = 1
            Wave1 = 1
            Wave2 = 0
            Wave3 = 0
            DefWorkstation = $True
            DefCloud = $False
            DefOnPrem = $False
            DefNetworking = $False
            DefSecurity = $False
            DefCharacter = $True
            IntroductionText = "A Haggard Workhorse clops into view very, very slowly."
            FailureText = "The Haggard Workhorse somehow gets away."
            FailurePenalty = ""
            WaveSuccessText = ""
            DeathText = "You cow the Haggard Workhorse with your unflappable persistence!"
            Opportunity = $True
        },
        @{
            Name = "Phish"
            ReqProjectStage = 1
            Wave1 = 1
            Wave2 = 0
            Wave3 = 0
            DefWorkstation = $True
            DefCloud = $True
            DefOnPrem = $False
            DefNetworking = $False
            DefSecurity = $True
            DefCharacter = $True
            IntroductionText = "A phish eyes you from the reeds."
            FailureText = "The phish wriggles out of your grip."
            FailurePenalty = ""
            WaveSuccessText = ""
            DeathText = "You caught a phish!"
            Opportunity = $False
        },
        @{
            Name = "Offline Server"
            ReqProjectStage = 2
            Wave1 = 2
            Wave2 = 0
            Wave3 = 0
            DefWorkstation = $False
            DefCloud = $False
            DefOnPrem = $True
            DefNetworking = $True
            DefSecurity = $False
            DefCharacter = $True
            IntroductionText = "A chill and immaterial moan signifies the presence of an Offline Server."
            FailureText = "The Offline Server has overcome you with its absence."
            FailurePenalty = ""
            WaveSuccessText = ""
            DeathText = "An electric pulse beats, and the Offline Server hums back to life."
            Opportunity = $True
        },
        @{
            Name = "Down WAP"
            ReqProjectStage = 2
            Wave1 = 1
            Wave2 = 1
            Wave3 = 0
            DefWorkstation = $False
            DefCloud = $False
            DefOnPrem = $False
            DefNetworking = $True
            DefSecurity = $False
            DefCharacter = $True
            IntroductionText = "A Down WAP looks ready to wap you down."
            FailureText = "The Down WAP wapped you down."
            FailurePenalty = ""
            WaveSuccessText = ""
            DeathText = "You wapped the Down WAP down!"
            Opportunity = $False
        }
    )
    #Separate file and only call when needed. 
    $global:AVNServiceTicketEncounterDefenseText = @(
        "The $ENTERTHEAPPROPRIATEVARIABLEHERE somehow avoided your attack. How did you miss?",
        ""
    )

}
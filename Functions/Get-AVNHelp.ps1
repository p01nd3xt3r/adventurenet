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
Function Get-AVNHelp {
    param (
        [Parameter()][switch]$Dice,
        [Parameter()][switch]$Functions
    )
    Get-AVNConfig

    If (($False -eq $Functions) -and ($False -eq $Dice)) {
        $Dice = $True
        $Functions = $True
    }

    If ($True -eq $Functions) {
        Write-Host "Several functions are only used by the system. Here are the ones you'll actually use:`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
@"
Invoke-AVNSignOn
The first function you'll use at the beginning of each day. It initiates your different daily alottments: turns, service ticket assignments, opportunities, and daily dice alottments. It also converts old service tickets into Technical Questions that other users can answer.

Get-AVNStatus
Currently diplays a smattering of information. Eventually it will only show formatted info that standard players would  use. Several other functions call this automatically.

Get-AVNHelp 
You're here. Adding -dice or -functions specifies what kind of help you want to see.

Close-AVNServiceTicket
The meat-and-potatoes of each day. Players will engage Service Tickets here, gaining Kudos and GIFs while decreasing Team Health. Unanswered Service Tickets become Technical Questions after a specified interval and decrease Client Health in the process. Failed Service Tickets become Technical Questions immediately and decrease Team and Client Health an additional amount. Players will also have a chance of finding Specials here.

Close-AVNProjectStage
The big momma. Projects have three stages with three waves of defenses apiece. They also have a chance of counter-attacking. Defeating Stages before their deadlines provides bonuses to Client Health and to a player's Kudos, and defeating the final Stage ends the season (once players use all their remaining turns). Functions much the same as Close-AVNServiceTicket.
"@
        Wait-AVNKeyPress
@"
Close-AVNTechnicalQuestions
Service tickets older than the configured threshold become Technical Questions. Other players will answer them here, increasing Client Health and gaining Kudos while doing so.

Enter-AVNTeams
Players will find GIFs while closing service tickets, and they may use those GIFs to purchase powerful Specials here.

Get-AVNTraining
Players are allowed to train once per day. Training allows players to add a single die of any type to his or her permanent dice collection.

Invoke-AVNSpecial
Players will find different Specials while closing service tickets, and any Specials of the General type will be available for use here.

Get-AVNConfig is also import to know about, though you'll almost never need to run it by itself, since most functions run it right away. This is how PS gets information from the data files created for each player and also how it gets information from AdventureNet.config for setting game options. This is, along with the actual data files, provides the framework for the rest of the functions. Running it by itself doesn't hurt anything, though.
"@
        Wait-AVNKeyPress
    }

    If ($True -eq $Dice) {
        #Getting dice info table.
        (Get-Content -path ($global:AVNRootPath + "\bGBIuKWniXYw")) | ForEach-Object {
            Invoke-Expression $_
        }
        Write-Host "`nDice are used for completing work. Service Ticket and Project Stages present work of different types.`nEach die has six sides, each of which represents a particular work type.`nA die's type indicates both the work types included on that die and the number of sides that have each of those types.`n`nDice types include:`nCore Values`nMicrosoft 365`nDatto`nMimecast/Umbrella`nWindows`nHuntress/Defender`nIT Glue`n`nWork types include:`nWorkstation`nCloud`nOn Prem`nNetworking`nSecurity`nCharacter`n`nAnd here is the work type breakdown for all dice`n" -foregroundcolor $global:AVNDefaultTextForegroundColor

        Write-Host "`nMimecastUmbrella" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNDiceValues.MimecastUmbrella
        Write-Host "`nMicrosoft365" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNDiceValues.Microsoft365
        Write-Host "`nDatto" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNDiceValues.Datto
        Wait-AVNKeyPress
        Write-Host "`nITGlue" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNDiceValues.ITGlue
        Write-Host "`nHuntressDefender" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNDiceValues.HuntressDefender
        Write-Host "`nWindows" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNDiceValues.Windows
        Write-Host "`nCoreValues" -foregroundcolor $global:AVNDefaultTextForegroundColor
        $AVNDiceValues.CoreValues
        Wait-AVNKeyPress
    }
}
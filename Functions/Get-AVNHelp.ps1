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
        [Parameter()][switch]$Functions,
        [Parameter()][switch]$Dice,
        [Parameter()][switch]$Specials,
        [Parameter()][switch]$Encounters,
        [Parameter()][switch]$Rolls
    )
    Get-AVNConfig

    If (($False -eq $Functions) -and ($False -eq $Dice) -and ($False -eq $Specials) -and ($False -eq $Encounters) -and ($False -eq $Rolls)) {
        $Functions = $True
        $Dice = $True
        $Specials = $True
        
        #Intro Graphic
        $AVNHelpAnim = Get-Content ($AVNRootPath + "\Media\AVNHelpAnim")
        $AVNHelpAnim  | ForEach-Object {
            Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
            Start-Sleep -Milliseconds 20
        }

        Write-Host "⣿ADVENTURENET⣿ Help ⣿`n`nNote that you can use various parameters to specify which help you want to see:`n- Functions`n- Dice`n- Specials`n- (soon to be others as well)" -foregroundcolor $global:AVNDefaultTextForegroundColor

        Wait-AVNKeyPress
    }

    If ($True -eq $Functions) {
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Functions ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "`nSeveral functions are only used by the system. Here are the ones you'll actually use:`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
@"
Invoke-AVNSignOn
The first function you'll use at the beginning of each day. It initiates your different daily alottments: turns, service ticket assignments, opportunities, and daily dice alottments. It also converts old service tickets into Technical Questions that other users can answer.

Get-AVNStatus
Displays current stats of yours and of your team's.

Get-AVNHelp 
You're here. Adding -dice or -specials or -encounters or -rolls or -functions specifies what kind of help you want to see.

Close-AVNServiceTicket
The meat-and-potatoes of each day. Players will engage Service Tickets here, gaining Kudos and GIFs while decreasing Team Health. Unanswered Service Tickets become Technical Questions after a specified interval and decrease Client Health in the process. Failed Service Tickets become Technical Questions immediately and decrease Client Health as well. Players will also have a chance of finding Specials or Crises here.

Close-AVNProjectBloc
The big momma. Projects have three stages with three waves of defenses apiece. At the beginning of each season, blocs are added to the Project based on the number of players that join--note, though, that this can be less than the total number of players, so attack them while you can. Differences between the Project and Service Tickets are that the Project's waves of defenses are always the same, while Service Tickets vary (and are generally easier). Projects also have a chance of counter-attacking. Defeating blocs of a particular stage before the stage's deadline provides bonuses to Client Health and to a player's Kudos, and defeating the final Stage ends the season (once players use all their remaining turns).
"@
        Wait-AVNKeyPress
@"
Close-AVNTechnicalQuestions
Service tickets older than the configured threshold become Technical Questions. Other players will answer them here, increasing Client Health and gaining Kudos while doing so.

Enter-AVNTeams
Players will find GIFs while closing service tickets, and they may use those GIFs to purchase powerful Specials here.

Get-AVNGIFs
Players may trade their unwanted Specials for a small GIF reward.

Get-AVNTraining
Players are allowed to train once per day. Training allows players to add a single die of any type to his or her permanent dice collection.

Invoke-AVNSpecial
Players will find different Specials while closing service tickets, and any Specials of the General type will be available for use here.

Get-AVNConfig is also import to know about, though you'll almost never need to run it by itself, since most functions run it right away. This is how PS gets information from the data files created for each player and also how it gets information from AdventureNet.config for setting game options. This, along with the actual data files, provides the framework for the rest of the functions. Running it by itself doesn't hurt anything, though.

Close-AVNSeason converts current data in all player data files into historical data and then resets current data. This cannot be undone, but it will need to be done before any subsequent season.
"@
        Wait-AVNKeyPress
    }

    If ($True -eq $Dice) {

        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Dice ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor

        #Getting dice info table.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\bGBIuKWniXYw")
        $AVNDataFileContent | ForEach-Object {
        Invoke-Expression $_
        }
        
        Write-Host "`nDice represent what work you attempt in Service Tickets and Project Stages. `nEach die has six sides, each of which represents a particular work type.`n`nA die's type indicates the breakdown of its work types." -foregroundcolor $global:AVNDefaultTextForegroundColor

        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Dice ⣿ MimecastUmbrella ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Workstation:       " $AVNDiceValues.MimecastUmbrella["Workstation"]
        Write-Host "Cloud:             " $AVNDiceValues.MimecastUmbrella["Cloud"]
        Write-Host "OnPrem:            " $AVNDiceValues.MimecastUmbrella["OnPrem"]
        Write-Host "Networking:        " $AVNDiceValues.MimecastUmbrella["Networking"]
        Write-Host "Security:          " $AVNDiceValues.MimecastUmbrella["Security"]
        Write-Host "Character:         " $AVNDiceValues.MimecastUmbrella["Character"]
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Dice ⣿ Microsoft365 ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Workstation:       " $AVNDiceValues.Microsoft365["Workstation"]
        Write-Host "Cloud:             " $AVNDiceValues.Microsoft365["Cloud"]
        Write-Host "OnPrem:            " $AVNDiceValues.Microsoft365["OnPrem"]
        Write-Host "Networking:        " $AVNDiceValues.Microsoft365["Networking"]
        Write-Host "Security:          " $AVNDiceValues.Microsoft365["Security"]
        Write-Host "Character:         " $AVNDiceValues.Microsoft365["Character"]
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Dice ⣿ Datto ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Workstation:       " $AVNDiceValues.Datto["Workstation"]
        Write-Host "Cloud:             " $AVNDiceValues.Datto["Cloud"]
        Write-Host "OnPrem:            " $AVNDiceValues.Datto["OnPrem"]
        Write-Host "Networking:        " $AVNDiceValues.Datto["Networking"]
        Write-Host "Security:          " $AVNDiceValues.Datto["Security"]
        Write-Host "Character:         " $AVNDiceValues.Datto["Character"]
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Dice ⣿ ITGlue ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Workstation:       " $AVNDiceValues.ITGlue["Workstation"]
        Write-Host "Cloud:             " $AVNDiceValues.ITGlue["Cloud"]
        Write-Host "OnPrem:            " $AVNDiceValues.ITGlue["OnPrem"]
        Write-Host "Networking:        " $AVNDiceValues.ITGlue["Networking"]
        Write-Host "Security:          " $AVNDiceValues.ITGlue["Security"]
        Write-Host "Character:         " $AVNDiceValues.ITGlue["Character"]
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Dice ⣿ HuntressDefender ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Workstation:       " $AVNDiceValues.HuntressDefender["Workstation"]
        Write-Host "Cloud:             " $AVNDiceValues.HuntressDefender["Cloud"]
        Write-Host "OnPrem:            " $AVNDiceValues.HuntressDefender["OnPrem"]
        Write-Host "Networking:        " $AVNDiceValues.HuntressDefender["Networking"]
        Write-Host "Security:          " $AVNDiceValues.HuntressDefender["Security"]
        Write-Host "Character:         " $AVNDiceValues.HuntressDefender["Character"]
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Dice ⣿ Windows ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Workstation:       " $AVNDiceValues.Windows["Workstation"]
        Write-Host "Cloud:             " $AVNDiceValues.Windows["Cloud"]
        Write-Host "OnPrem:            " $AVNDiceValues.Windows["OnPrem"]
        Write-Host "Networking:        " $AVNDiceValues.Windows["Networking"]
        Write-Host "Security:          " $AVNDiceValues.Windows["Security"]
        Write-Host "Character:         " $AVNDiceValues.Windows["Character"]
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Dice ⣿ CoreValues ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Workstation:       " $AVNDiceValues.CoreValues["Workstation"]
        Write-Host "Cloud:             " $AVNDiceValues.CoreValues["Cloud"]
        Write-Host "OnPrem:            " $AVNDiceValues.CoreValues["OnPrem"]
        Write-Host "Networking:        " $AVNDiceValues.CoreValues["Networking"]
        Write-Host "Security:          " $AVNDiceValues.CoreValues["Security"]
        Write-Host "Character:         " $AVNDiceValues.CoreValues["Character"]
    
        Wait-AVNKeyPress
    }
    If ($True -eq $Specials) {
        #Getting specials. Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
        $AVNDataFileContent | ForEach-Object {
            Invoke-Expression $_
        }

        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Specials ⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "A Special's type determines where it may be used, where it may be found, and what kinds of things it allows you to do." -foregroundcolor $global:AVNDefaultTextForegroundColor
        
        $AVNGeneralSpecialsTable = @(
            ForEach ($AVNSpecial in $AVNSpecials) {
                If (($AVNSpecial.type -eq "General") -and ($AVNSpecial.teamscost -eq 0)) {
                    $AVNGeneralSpecialProperties = [ordered]@{
                        Name = $AVNSpecial.name
                        Type = $AVNSpecial.type
                        Description = $AVNSpecial.description
                        Effect = $AVNSpecial.EffectDescription
                    }
                    New-Object psobject -property $AVNGeneralSpecialProperties
                }
            }
        )
        Write-Host "`n`n⣿ADVENTURENET⣿ Help ⣿ Specials ⣿ Type: General ⣿`nGeneral Specials are used within the Invoke-AVNSpecial function." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNGeneralSpecialsTable | Sort-Object name | Format-Table Name,Effect

        $AVNInstantSpecialsTable = @(
            ForEach ($AVNSpecial in $AVNSpecials) {
                If (($AVNSpecial.type -eq "Instant") -and ($AVNSpecial.teamscost -eq 0)) {
                    $AVNInstantSpecialProperties = [ordered]@{
                        Name = $AVNSpecial.name
                        Type = $AVNSpecial.type
                        Description = $AVNSpecial.description
                        Effect = $AVNSpecial.EffectDescription
                    }
                    New-Object psobject -property $AVNInstantSpecialProperties
                }
            }
        )
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Specials ⣿ Type: Instant ⣿`nInstant Specials take effect as soon as you find them." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNInstantSpecialsTable | Sort-Object name | Format-Table Name,Effect

        $AVNPreEmptiveSpecialsTable = @(
            ForEach ($AVNSpecial in $AVNSpecials) {
                If (($AVNSpecial.type -eq "PreEmptive") -and ($AVNSpecial.teamscost -eq 0)) {
                    $AVNPreEmptiveSpecialProperties = [ordered]@{
                        Name = $AVNSpecial.name
                        Type = $AVNSpecial.type
                        Description = $AVNSpecial.description
                        Effect = $AVNSpecial.EffectDescription
                    }
                    New-Object psobject -property $AVNPreEmptiveSpecialProperties
                }
            }
        )
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Specials ⣿ Type: PreEmptive ⣿`nPreEmptive Specials are used before the first wave during either Close-AVNServiceTicket or Close-AVNProjectBloc." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNPreEmptiveSpecialsTable | Sort-Object name | Format-Table Name,Effect

        $AVNInterruptSpecialsTable = @(
            ForEach ($AVNSpecial in $AVNSpecials) {
                If (($AVNSpecial.type -eq "Interrupt") -and ($AVNSpecial.teamscost -eq 0)) {
                    $AVNInterruptSpecialProperties = [ordered]@{
                        Name = $AVNSpecial.name
                        Type = $AVNSpecial.type
                        Description = $AVNSpecial.description
                        Effect = $AVNSpecial.EffectDescription
                    }
                    New-Object psobject -property $AVNInterruptSpecialProperties
                }
            }
        )
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Specials ⣿ Type: Interrupt ⣿`nInterrupt Specials are used before the second or third waves during either Close-AVNServiceTicket or Close-AVNProjectBloc." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNInterruptSpecialsTable | Sort-Object name | Format-Table Name,Effect

        $AVNInjectionSpecialsTable = @(
            ForEach ($AVNSpecial in $AVNSpecials) {
                If (($AVNSpecial.type -eq "injection") -and ($AVNSpecial.teamscost -eq 0)) {
                    $AVNInjectionSpecialProperties = [ordered]@{
                        Name = $AVNSpecial.name
                        Type = $AVNSpecial.type
                        Description = $AVNSpecial.description
                        Effect = $AVNSpecial.EffectDescription
                    }
                    New-Object psobject -property $AVNInjectionSpecialProperties
                }
            }
        )
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Specials ⣿ Type: Injection ⣿`nInjection Specials provide a boost to any roll, adding additional worktypes to the dice results that you've already rolled." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNInjectionSpecialsTable | Sort-Object name | Format-Table Name,Effect

        $AVNTeamsSpecialsTable = @(
            ForEach ($AVNSpecial in $AVNSpecials) {
                If ($AVNSpecial.teamscost -gt 0) {
                    $AVNTeamsSpecialProperties = [ordered]@{
                        Name = $AVNSpecial.name
                        Type = $AVNSpecial.type
                        Description = $AVNSpecial.description
                        Effect = $AVNSpecial.EffectDescription
                    }
                    New-Object psobject -property $AVNTeamsSpecialProperties
                }
            }
        )
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Specials ⣿ Type: Teams-Purchasable ⣿`nThese varied Specials may be purchased with GIFs within Enter-AVNTeams." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNTeamsSpecialsTable | Sort-Object name | Format-Table Name,Type,Effect

        $AVNCrisisSpecialsTable = @(
            ForEach ($AVNSpecial in $AVNSpecials) {
                If ($AVNSpecial.type -eq "crisis") {
                    $AVNCrisisSpecialProperties = [ordered]@{
                        Name = $AVNSpecial.name
                        Type = $AVNSpecial.type
                        Description = $AVNSpecial.description
                        Effect = $AVNSpecial.EffectDescription
                    }
                    New-Object psobject -property $AVNCrisisSpecialProperties
                }
            }
        )
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Specials ⣿ Type: Crisis ⣿`nCrises work like Instant Specials, but you don't want to find these." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNCrisisSpecialsTable | Sort-Object name | Format-Table Name,Effect
        
        Wait-AVNKeyPress
    }
    If ($True -eq $Encounters) {
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Encounters ⣿`nPlaceholder text." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Wait-AVNKeyPress
    }
    If ($True -eq $Rolls) {
        Write-Host "`n⣿ADVENTURENET⣿ Help ⣿ Rolls ⣿`nPlaceholder text." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Wait-AVNKeyPress
    }
}
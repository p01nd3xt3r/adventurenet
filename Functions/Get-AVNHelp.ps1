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
        [Parameter()][switch]$Specials
    )
    Get-AVNConfig

    If (($False -eq $Functions) -and ($False -eq $Dice) -and ($False -eq $Specials)) {
        $Functions = $True
        $Dice = $True
        $Specials = $True
        
        #Intro Graphic
        $AVNHelpAnim = Get-Content ($AVNRootPath + "\Media\AVNHelpAnim")
        $AVNHelpAnim  | ForEach-Object {
            Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
            Start-Sleep -Milliseconds 20
        }
    }

    If ($True -eq $Functions) {
        Write-Host "`n⣿ADVENTURENET⣿Help: Functions⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "`nSeveral functions are only used by the system. Here are the ones you'll actually use:`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
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

Close-AVNSeason converts current data in all player data files into historical data and then to reset current data. This cannot be undone, but it will need to be done before any subsequent season.
"@
        Wait-AVNKeyPress
    }

    If ($True -eq $Dice) {

        Write-Host "`n⣿ADVENTURENET⣿Help: Dice⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor

        #Getting dice info table.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\bGBIuKWniXYw")
        $AVNDataFileContent | ForEach-Object {
        Invoke-Expression $_
        }
        
        Write-Host "`nDice represent what work you attempt in Service Tickets and Project Stages. `nEach die has six sides, each of which represents a particular work type.`n`nA die's type indicates the breakdown of its work types." -foregroundcolor $global:AVNDefaultTextForegroundColor

        Write-Host "`n`n⣿Dice Breakdown⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "`nMimecastUmbrella" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNDiceValues.MimecastUmbrella | Format-Table -HideTableHeaders
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
    If ($True -eq $Specials) {
        #Getting specials. Yields the $AVNSpecials array of hashtables, which is the cipher for specials.
        $AVNDataFileContent = ConvertFrom-AVNObfuscated -path ($global:AVNRootPath + "\XQxoHZJajcgW")
        $AVNDataFileContent | ForEach-Object {
            Invoke-Expression $_
        }

        Write-Host "`n⣿ADVENTURENET⣿Help: Specials⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Host "Basic description and how you get them and introduction of types here." -foregroundcolor $global:AVNDefaultTextForegroundColor
        
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
        Write-Host "`n`n⣿Type: General⣿`nGeneral Specials are used within the Invoke-AVNSpecial function." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNGeneralSpecialsTable | Sort-Object "type" | Format-Table Name,Effect

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
        Write-Host "`n⣿Type: Instant⣿`nInstant Specials take effect as soon as you attain them." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNInstantSpecialsTable | Sort-Object "type" | Format-Table Name,Effect

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
        Write-Host "`n⣿Type: PreEmptive⣿`nPreEmptive Specials are used before the first wave during either Close-AVNServiceTicket or Close-AVNProjectStage." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNPreEmptiveSpecialsTable | Sort-Object "type" | Format-Table Name,Effect

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
        Write-Host "`n⣿Type: Interrupt⣿`nInterrupt Specials are used before the second or third waves during either Close-AVNServiceTicket or Close-AVNProjectStage." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNInterruptSpecialsTable | Sort-Object "type" | Format-Table Name,Effect

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
        Write-Host "`n⣿Type: Injection⣿`nInjection Specials provide a boost to any roll, adding additional worktypes to the dice results that you've already rolled." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNInjectionSpecialsTable | Sort-Object "type" | Format-Table Name,Effect

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
        Write-Host "`n⣿Type: Teams-Purchasable⣿`nThese varied Specials may be purchased with GIFs within Enter-AVNTeams." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Write-Output $AVNTeamsSpecialsTable | Sort-Object "type" | Format-Table Name,Type,Effect
    }
}
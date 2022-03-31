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
Function Set-AVNPrompt {
    If ($PSVersiontable.psedition -eq "desktop") {
        Write-Host "`nWindows Powershell does not currently support Set-AVNPrompt. Please use Powershell (Powershell Core) instead.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
    } Else {
        Get-AVNConfig
        Function global:Prompt {
            $AVNInfoLine = "⣿ADVENTURENET⣿ Stage: " + $global:AVNCompanyDataCommon.currentstage + " ⣿ Turns: " + $global:AVNPlayerData_CurrentPlayer.turns + " ⣿ ClientHealth: " + $global:AVNCompanyDataCommon.clienthealth + " ⣿ TeamHealth: " + $global:AVNCompanyDataCommon.teamhealth + " ⣿ Kudos: " + $global:AVNPlayerData_CurrentPlayer.kudos + " ⣿ GIFs: " + $global:AVNPlayerData_CurrentPlayer.gifs + " ⣿"
            $AVNPromptLine = "`nPS " + (get-location).path + "> "
            
            "`e[32m$AVNInfoLine`e[34m$AVNPromptLine`e[0m"
        }

        Write-Host "`e[34m`nTo revert your prompt to normal, just close and reopen Powershell.`n`e[0m"
    }
}
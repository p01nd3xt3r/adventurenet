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
    Get-AVNConfig
    Function global:Prompt {
        $AVNInfoLine = "⣿ADVENTURENET⣿ Stage: " + $global:AVNCompanyDataCommon.currentstage + " ⣿ Turns: " + $global:AVNPlayerData_CurrentPlayer.turns + " ⣿ ClientHealth: " + $global:AVNCompanyDataCommon.teamhealth + " ⣿ TeamHealth: " + $global:AVNCompanyDataCommon.teamhealth + " ⣿ Kudos: " + $global:AVNPlayerData_CurrentPlayer.kudos + " ⣿ GIFs: " + $global:AVNPlayerData_CurrentPlayer.gifs + " ⣿`n> "
        "`e[32m$AVNInfoLine`e[0m"
    }

    Write-Host "`nTo revert your prompt to normal, just close and reopen Powershell.`n" -foregroundcolor magenta
}
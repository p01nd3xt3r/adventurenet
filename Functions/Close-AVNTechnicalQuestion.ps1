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
Function Close-AVNTechnicalQuestion {
    Get-AVNConfig

    If ($global:AVNCompanyDataCommon.technicalquestionsavailable -lt 1) {
        Write-Host "There are no technical questions to close." -foregroundcolor $global:AVNDefaultTextForegroundColor
        Return
    }
    If ($global:AVNCompanyDataCommon.clienthealth -lt 20) {
         Else {

        }
    }
    
    Do {
        Write-Host "Technical questions are service tickets that other players have either failed or else failed to answer within two days of them being assigned. Having no technical questions provides a bonus to client health, and answering them adds kudos to whomever answers them." -foregroundcolor $global:AVNDefaultTextForegroundColor
        If ($global:AVNCompanyDataCommon.clienthealth -gt 19) {
            Write-Host "Doing so requires two of your turns." -foregroundcolor $global:AVNDefaultTextForegroundColor
            If ($global:AVNPlayerData_CurrentPlayer.turn -lt 2) {
                Write-Host "You do not have enough turns." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
        } ElseIf ($global:AVNCompanyDataCommon.clienthealth -gt 9) {
            Write-Host "As a result of low client health, doing so requires two turns and 10 GIFs. Your GIFs:" -foregroundcolor $global:AVNDefaultTextForegroundColor
            $global:AVNPlayerData_CurrentPlayer.gifs
            If ($global:AVNPlayerData_CurrentPlayer.gifs -lt 10) {
                Write-Host "You do not have enough GIFs." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
            If ($global:AVNPlayerData_CurrentPlayer.turn -lt 2) {
                Write-Host "You do not have enough turns." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
        } Else {
            Write-Host "As a result of low client health, doing so requires three of your turns and 10 GIFs. Your GIFs:" -foregroundcolor $global:AVNDefaultTextForegroundColor
            $global:AVNPlayerData_CurrentPlayer.gifs
            If ($global:AVNPlayerData_CurrentPlayer.gifs -lt 10) {
                Write-Host "You do not have enough GIFs." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
            If ($global:AVNPlayerData_CurrentPlayer.turn -lt 3) {
                Write-Host "You do not have enough turns." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
        }

        $AVNTechConfirmation = "n"
        $AVNTechConfirmation = Read-Host "Would you like to proceed? (y/n)"
        If (($AVNTechConfirmation -ne "y") -and ($AVNTechConfirmation -ne "yes") -and ($AVNTechConfirmation -ne 'n') -and ($AVNTechConfirmation -ne 'no')) {
            Write-Host "You've entered something odd. Please only enter y or n." -foregroundcolor $global:AVNDefaultTextForegroundColor
        }
    } Until (($AVNTechConfirmation -eq "y") -or ($AVNTechConfirmation -eq "yes") -or ($AVNTechConfirmation -eq 'n') -or ($AVNTechConfirmation -eq 'no'))

    If (($AVNTechConfirmation -eq "y") -or ($AVNTechConfirmation -eq "yes")) {
        $global:AVNPlayerData_CurrentPlayer.kudos += 1
        If ($global:AVNCompanyDataCommon.clienthealth -gt 19) {
            $global:AVNPlayerData_CurrentPlayer.turns -= 2
        } ElseIf ($global:AVNCompanyDataCommon.clienthealth -gt 9) {
            $global:AVNPlayerData_CurrentPlayer.turns -= 2
            $global:AVNPlayerData_CurrentPlayer.gifs -= 10
        } Else {
            $global:AVNPlayerData_CurrentPlayer.turns -= 3
            $global:AVNPlayerData_CurrentPlayer.gifs -= 10
        }
        
        $global:AVNCompanyData_CurrentPlayer.technicalquestionsremoved -= 1
        $global:AVNCompanyData_CurrentPlayer.clienthealth += 1
        $global:AVNPlayerData_CurrentPlayer.kudos += 1
        $global:AVNPlayerData_CurrentPlayer.globalnotice = "closed a technical question."
        Write-Host "You closed a technical question and increased Client Health by 1." -foregroundcolor $global:AVNDefaultTextForegroundColor

        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
        
        Wait-AVNKeyPress
    } Else {
        Return
    }
}
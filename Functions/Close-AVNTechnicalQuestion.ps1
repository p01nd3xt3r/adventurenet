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

    #Intro Graphic
    $AVNTechQAnim = Get-Content ($AVNRootPath + "\Media\AVNTechQAnim")
    $AVNTechQAnim | ForEach-Object {
        Write-Host $_ -foregroundcolor $global:AVNDefaultBannerForegroundColor
        Start-Sleep -Milliseconds 20
    }
    Write-Host "⣿ADVENTURENET⣿Technical Questions⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
    
    If ($global:AVNCompanyDataCommon.technicalquestionsavailable -lt 1) {
        Write-Host "`nThere are no Technical Questions to close.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor
        Return
    }
    
    Do {
        Write-Host "`nService Tickets that aren't closed within the configured interval or that are failed by their assignees convert into Technical Questions. Closing them adds 1 to your Kudos and to Client Health." -foregroundcolor $global:AVNDefaultTextForegroundColor
        If ($global:AVNCompanyDataCommon.clienthealth -ge $global:AVNPenaltyThresholdOne) {
            Write-Host "`nDoing so will require 2 of your turns." -foregroundcolor $global:AVNDefaultTextForegroundColor
            If ($global:AVNPlayerData_CurrentPlayer.turns -lt 2) {
                Write-Host "`nYou do not have enough turns." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
        } ElseIf ($global:AVNCompanyDataCommon.clienthealth -ge $global:AVNPenaltyThresholdThree) {
            Write-Host "`nAs a result of low client health, closing a Technical Question will require 2 turns and 10 GIFs. Your GIFs:" -foregroundcolor $global:AVNDefaultTextForegroundColor
            $global:AVNPlayerData_CurrentPlayer.gifs
            If ($global:AVNPlayerData_CurrentPlayer.gifs -lt 10) {
                Write-Host "`nYou do not have enough GIFs." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
            If ($global:AVNPlayerData_CurrentPlayer.turn -lt 2) {
                Write-Host "`nYou do not have enough turns." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
        } Else {
            Write-Host "`nAs a result of low client health, closing a Technical Question will require 3 of your turns and 10 GIFs. Your GIFs:" -foregroundcolor $global:AVNDefaultTextForegroundColor
            $global:AVNPlayerData_CurrentPlayer.gifs
            If ($global:AVNPlayerData_CurrentPlayer.gifs -lt 10) {
                Write-Host "`nYou do not have enough GIFs." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
            If ($global:AVNPlayerData_CurrentPlayer.turn -lt 3) {
                Write-Host "`nYou do not have enough turns." -foregroundcolor $global:AVNDefaultTextForegroundColor
                Return
            }
        }

        $AVNTechConfirmation = "n"
        $AVNTechConfirmation = Read-Host "Would you like to proceed? (y/n)"
        If (($AVNTechConfirmation -ne "y") -and ($AVNTechConfirmation -ne "yes") -and ($AVNTechConfirmation -ne 'n') -and ($AVNTechConfirmation -ne 'no')) {
            Write-Host "`nYou've entered something odd. Please only enter y or n." -foregroundcolor $global:AVNDefaultTextForegroundColor
        }
    } Until (($AVNTechConfirmation -eq "y") -or ($AVNTechConfirmation -eq "yes") -or ($AVNTechConfirmation -eq 'n') -or ($AVNTechConfirmation -eq 'no'))

    If (($AVNTechConfirmation -eq "y") -or ($AVNTechConfirmation -eq "yes")) {
        $global:AVNPlayerData_CurrentPlayer.kudos += 1
        If ($global:AVNCompanyDataCommon.clienthealth -ge $global:AVNPenaltyThresholdOne) {
            $global:AVNPlayerData_CurrentPlayer.turns -= 2
        } ElseIf ($global:AVNCompanyDataCommon.clienthealth -ge $global:AVNPenaltyThresholdThree) {
            $global:AVNPlayerData_CurrentPlayer.turns -= 2
            $global:AVNPlayerData_CurrentPlayer.gifs -= 10
        } Else {
            $global:AVNPlayerData_CurrentPlayer.turns -= 3
            $global:AVNPlayerData_CurrentPlayer.gifs -= 10
        }
        
        $global:AVNCompanyData_CurrentPlayer.technicalquestionsremoved += 1
        $global:AVNCompanyData_CurrentPlayer.clienthealth += 1
        $global:AVNPlayerData_CurrentPlayer.kudos += 1
        $global:AVNPlayerData_CurrentPlayer.globalnotice = "closed a technical question."
        Write-Host "`nYou closed a Technical Question and increased Client Health by 1.`n" -foregroundcolor $global:AVNDefaultTextForegroundColor

        ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
    } Else {
        Return
    }
}
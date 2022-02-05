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
Function Add-AVNProjectWaves {
    param (
        [Parameter()][switch]$System
    )

    If ($False -eq $System) {
        Throw "Do not run this function on its own. Doing so runs the risk of ruining everyone's data files permanently. Plus, it's cheating."
    }

    If ($False -eq $global:AVNCompanyDataCommon.ProjectWavesGenerated) {
        $global:AVNCompanyData_CurrentPlayer.ProjectStage1WaveGenerated = 1
        $global:AVNCompanyData_CurrentPlayer.ProjectStage2WaveGenerated = 1
        $global:AVNCompanyData_CurrentPlayer.ProjectStage3WaveGenerated = 1
        #$global:AVNCompanyDataCommon.ProjectWavesGenerated will update itself when avn-getconfig runs again, after the above data is written to the data file and then read.
    } Else {
        #Generating project stage waves with appropriate chance.
        $AVNProjectStage1WaveGenerationRoll = Get-Random -minimum 0 -maximum 100
        If ($AVNProjectStage1WaveGenerationRoll -lt ($global:AVNProjectWaveGenerationRate * 100)) {
            $global:AVNCompanyData_CurrentPlayer.ProjectStage1WaveGenerated = 1
        }
        $AVNProjectStage2WaveGenerationRoll = Get-Random -minimum 0 -maximum 100
        If ($AVNProjectStage2WaveGenerationRoll -lt ($global:AVNProjectWaveGenerationRate * 100)) {
            $global:AVNCompanyData_CurrentPlayer.ProjectStage2WaveGenerated = 1
        }
        $AVNProjectStage3WaveGenerationRoll = Get-Random -minimum 0 -maximum 100
        If ($AVNProjectStage3WaveGenerationRoll -lt ($global:AVNProjectWaveGenerationRate * 100)) {
            $global:AVNCompanyData_CurrentPlayer.ProjectStage3WaveGenerated = 1
        }
    }

    #Waves should only ever be generated at the player's first run of the season.
    $global:AVNPlayerData_CurrentPlayer.seasonfirstrun = $False
    
    ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
}
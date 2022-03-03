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
Function Add-AVNProjectBloc {
    param (
        [Parameter()][switch]$System
    )

    If ($False -eq $System) {
        Throw "Do not run this function on its own. Doing so runs the risk of ruining everyone's data files permanently. Plus, it's cheating."
    }

    If ($False -eq $global:AVNCompanyDataCommon.ProjectBlocsGenerated) {
        $global:AVNCompanyData_CurrentPlayer.ProjectStage1BlocGenerated = 1
        $global:AVNCompanyData_CurrentPlayer.ProjectStage2BlocGenerated = 1
        $global:AVNCompanyData_CurrentPlayer.ProjectStage3BlocGenerated = 1
    } Else {
        #Generating project stage Blocs with appropriate chance.
        $AVNProjectStage1BlocGenerationRoll = Get-Random -minimum 0 -maximum 100
        If ($AVNProjectStage1BlocGenerationRoll -lt ($global:AVNProjectBlocGenerationRate * 100)) {
            $global:AVNCompanyData_CurrentPlayer.ProjectStage1BlocGenerated = 1
        }
        $AVNProjectStage2BlocGenerationRoll = Get-Random -minimum 0 -maximum 100
        If ($AVNProjectStage2BlocGenerationRoll -lt ($global:AVNProjectBlocGenerationRate * 100)) {
            $global:AVNCompanyData_CurrentPlayer.ProjectStage2BlocGenerated = 1
        }
        $AVNProjectStage3BlocGenerationRoll = Get-Random -minimum 0 -maximum 100
        If ($AVNProjectStage3BlocGenerationRoll -lt ($global:AVNProjectBlocGenerationRate * 100)) {
            $global:AVNCompanyData_CurrentPlayer.ProjectStage3BlocGenerated = 1
        }
    }

    #Blocs should only ever be generated at the player's first run of the season.
    $global:AVNPlayerData_CurrentPlayer.seasonfirstrun = $False
    
    ConvertTo-AVNWriteData -system | ConvertTo-AVNObfuscated -path $global:AVNCurrentPlayerDataFile
}
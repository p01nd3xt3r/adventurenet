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
Function Update-AVNProduction {
    param (
        [Parameter(helpmessage="Please only use this function if you're a dev.")][switch]$Dev
    )

    If (!($True -eq $Dev)) { 
        Throw "Please don't use this function if you're not a dev."
    }
    
    Get-AVNConfig
    
    If ($AVNProductionPath -eq $AVNRootPath) {
        Throw "You have the production module imported. This function should only be used from the dev module."
    }

    $ExcludedFiles = @(
        'data*',
        '.git*',
        'license',
        'readme.md'
    )  

    If (!(Test-Path -PathType "container" -path $AVNProductionPath)) { 
        New-Item -path $AVNProductionPath -itemtype "directory"
    }
    If (!(Test-Path -PathType "container" -path ($AVNProductionPath + "\data"))) { 
        New-Item -path ($AVNProductionPath + "\Data") -itemtype "directory"
    }
    Copy-Item -path ($AVNRootPath + "\*") -destination $AVNProductionPath -exclude $ExcludedFiles -force -recurse
}

#I don't need to run the update function but when sending my dev files to the production location! I'll be importing it from the dev sharepoint location anyways to make sure I hit any bugs that are specific to doing so.

#Send all files to the production location, which will be gathered from the config file in the dev location and identified from the imported module info. Don't include the update function, for one. Don't use a version folder, and don't send over dev \data files (player data). When I update, players will need to close their sessions for OneDrive to update the scripts, I assume. I wonder if I could add a second command for them to reload the module, though. I will have to test. I'm going to try to move the Github location to the sharepoint dev location.
#Need to provide a command to add the import function to their profiles. 

#It should have $AVNRootPath from Get-AVNConfig and should use that. Note that $AVNRootPath is for the imported module and only represents that same value as the production path if running from there. Adjust accordingly.

#Make any desired config file changes prior to running this update, if you want them sent from dev to production.

#Since this function won't be copied into production, no need to check to make sure it's being run from dev.
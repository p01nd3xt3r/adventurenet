#
# Module manifest for module 'AdventureNet'
#
# Generated by: PatrickPace
#
# Generated on: 12/17/2021
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
	# Major    - milestone, e.g. new module core
	# Minor    - new solutions, e.g. new cmdlets
	# Build    - new features, e.g. new params
	# Revision - fixed bugs, typos, etc...
ModuleVersion = '0.24.0.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '17d9bfad-8727-4d39-9e69-727e6b581ba3'

# Author of this module
Author = 'Patrick D. Pace'

# Company or vendor of this module
CompanyName = 'Patrick D. Pace'

# Copyright statement for this module
Copyright = '(c) Patrick D. Pace. All rights reserved.'

# Description of the functionality provided by this module
# Description = ''

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
    '.\Functions\Add-AVNPlayer.ps1',
    '.\Functions\Add-AVNProjectBloc.ps1',
    '.\Functions\Close-AVNProjectStage.ps1',
    '.\Functions\Close-AVNSeason.ps1',
    '.\Functions\Close-AVNServiceTicket.ps1',
    '.\Functions\Close-AVNTechnicalQuestion.ps1',
    '.\Functions\ConvertFrom-AVNObfuscated.ps1',
    '.\Functions\ConvertTo-AVNObfuscated.ps1',
    '.\Functions\ConvertTo-AVNWriteData.ps1',
    '.\Functions\Enter-AVNTeams.ps1',
    '.\Functions\Get-AVNConfig.ps1',
    '.\Functions\Get-AVNGIFs.ps1',
    '.\Functions\Get-AVNHelp.ps1',
    '.\Functions\Get-AVNStatus.ps1',
    '.\Functions\Get-AVNTraining.ps1',
    '.\Functions\Invoke-AVNSignOn.ps1',
    '.\Functions\Invoke-AVNSpecial.ps1',
    '.\Functions\Wait-AVNKeyPress.ps1'
)

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Add-AVNPlayer',
    'Add-AVNProjectBloc',
    'Close-AVNProjectStage',
    'Close-AVNSeason',
    'Close-AVNServiceTicket',
    'Close-AVNTechnicalQuestion',
    'ConvertFrom-AVNObfuscated',
    'ConvertTo-AVNObfuscated',
    'ConvertTo-AVNWriteData',
    'Enter-AVNTeams',
    'Get-AVNConfig',
    'Get-AVNGIFs',
    'Get-AVNHelp',
    'Get-AVNStatus',
    'Get-AVNTraining',
    'Invoke-AVNSignOn',
    'Invoke-AVNSpecial',
    'Wait-AVNKeyPress'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
#CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
# Make sure to add these as they come up. 
# AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @(
    '.\AdventureNet.config',
    '.\bGBIuKWniXYw',
    '.\CnJBNhPAkdty',
    '.\CreateAVNProfileShortcuts.ps1',
    '.\README.md',
    '.\uhGNpSAZCzIt',
    '.\wlBjUrtSsTIO',
    '.\XQxoHZJajcgW',
    '.\Media\AVNGIFsAnim',
    '.\Media\AVNHelpAnim',
    '.\Media\AVNIntroAnim',
    '.\Media\AVNServiceTicketAnim',
    '.\Media\AVNSpecialAnim',
    '.\Media\AVNStage1Anim',
    '.\Media\AVNStage2Anim',
    '.\Media\AVNStage3Anim',
    '.\Media\AVNStagesCompleteAnim',
    '.\Media\AVNTeamsAnim',
    '.\Media\AVNTechQAnim',
    '.\Media\AVNTrainingAnim',
    '.\Media\AVNVictoryAnim'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
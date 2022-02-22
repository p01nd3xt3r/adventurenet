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
Function Wait-AVNKeyPress {
    Write-Host "`n⣿Press any key to continue⣿" -foregroundcolor $global:AVNDefaultTextForegroundColor
    $HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,AllowCtrlC") | OUT-NULL  
    $HOST.UI.RawUI.Flushinputbuffer()   
}
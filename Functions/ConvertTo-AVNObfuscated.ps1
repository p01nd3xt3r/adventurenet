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
Function ConvertTo-AVNObfuscated {
    param (
        [parameter(ValueFromPipeline)][string]$PlainText = "",
        [parameter()][string]$Path = ""
    )

    #Takes in plain text and spits out encrypted text. If $AVNObfuscate is set to $False, sends text as-is.

    #I have this variable in config. If it's false, have the convert functions just take in the text and send it back as-is. 
    #$AVNObfuscate

    If ($True -eq $AVNObfuscate) {
        $SecureString = ConvertTo-SecureString "$PlainText" -AsPlainText -Force
        $EncryptedString = ConvertFrom-SecureString -SecureString $SecureString -Key (Get-Content ($AVNRootPath + "\CnJBNhPAkdty"))
    } Else {
        $EncryptedString = $PlainText
    }

    If ("" -ne $Path) {
        #Test path?
        Set-Content -path $Path -value $EncryptedString 
    } Else {
        Return $EncryptedString
    }
}
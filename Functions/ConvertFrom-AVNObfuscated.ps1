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
Function ConvertFrom-AVNObfuscated {
    param (
        [parameter(ValueFromPipeline)]$EncryptedString,
        [parameter()][string]$Path = ""
    )

    #Takes in encrypted text and spits out plain text. If $AVNObfuscate is set to $False, sends text as-is.
    
    #I have this variable in config. If it's false, have the convert functions just take in the text and send it back as-is. 
    #$AVNObfuscate
    If ("" -ne $Path) {
            $EncryptedString = Get-Content $Path
        }
    
    #Test path? This might not be working.
    
    If ($True -eq $AVNObfuscate) {
        $SecureString = ConvertTo-SecureString -String $EncryptedString -Key (Get-Content ($AVNRootPath + "\CnJBNhPAkdty"))
        $PlainText = ConvertFrom-SecureString -securestring $SecureString -asplaintext
        Return $PlainText
    } Else {
        Return $EncryptedString
    }
}
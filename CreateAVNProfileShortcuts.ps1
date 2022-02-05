#Add some functions to your PowerShell user profile that'll make managing your module import a bit easier.

Add-Content -path $Profile -value "`nFunction Import-AVN {Import-Module (`$env:userprofile + '(enter location here)\AdventureNet\AdventureNet.psd1')}"
Add-Content -path $Profile -value "`nFunction Sync-AVN {Remove-Module 'AdventureNet'; Import-AVN}"

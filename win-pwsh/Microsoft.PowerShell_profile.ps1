#starship init
Invoke-Expression (&starship init powershell)

#zoxide 
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})

#modules
Import-Module -Name Terminal-Icons

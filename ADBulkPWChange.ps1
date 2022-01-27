Function Random-Password ($length = 9) {
    $punc = 46..46
    $digits = 48..57
    $letters = 65..90 + 97..122
    $password = get-random -count $length `
    -input ($punc + $digits + $letters) |
    % -begin { $aa = $null } `
    -process {$aa += [char]$_} `
    -end {$aa}

    return $password
}

##  Use this method for changing all members in a specific group
$users = Get-ADGroupMember "Domain Admins"
##  Use this method for changing all users in a specific OU
# $users = Get-ADUser -Filter "Enabled -eq 'true'" -SearchBase OU 
## Get the list of accounts from the file, one username per line (comment out the line: $user = $user.samaccountname)
# $users = Get-Content -Path C:\Temp\userlist.txt
ForEach ($user in $users) {
    $user = $user.samaccountname
    $pass = Random-Password 
    ForEach ($password in $pass) {
        Set-ADAccountPassword $user -NewPassword (ConvertTo-SecureString -AsPlainText $password -force)
        Write-Host "$($user) has been reset with Password $($password)"
    }
}

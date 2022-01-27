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


$users = Get-ADGroupMember "Domain Admins"
## $users = Get-ADUser -Filter "Enabled -eq 'true'" -SearchBase OU 
ForEach ($user in $users) {
    $user = $user.samaccountname
    $pass = Random-Password 
    ForEach ($password in $pass) {
        Set-ADAccountPassword $user -NewPassword (ConvertTo-SecureString -AsPlainText $password -force)
        Write-Host "$($user) has been reset with Password $($password)"
    }
}
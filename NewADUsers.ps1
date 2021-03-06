# Imports from CSV the end users first name, last name, and description
# and uses that information to create a new AD User
#
# Written and tested by Bryan Bansbach - CMIT Solutions of Central RI

$newUsers = Import-CSV names.csv

foreach ($user in $newUsers) {
    $accountName = "$($user.givenname[0])$($user.surname)"   # Takes first inital and concatenates last name to that, no spaces (ie. BBansbach)
    $upn = "$($user.givenname[0])$($user.surname)@testdomain.com"   # Adds the domain name to the account name (ie. BBansbach@testdomain.com) **NOTE** UPDATE DOMAIN NAME AT THE END
    $displayname = $user.givenname + ' ' + $user.surname   # Concatenates the users first name and last name into a full name string with a space (ie. Bryan Bansbach)
    
    # These two lines take the account name and UPN above and converts them to all lowercase
    $accountName = $accountName.toLower()
    $upn = $upn.toLower()

    new-aduser -samAccountName $accountName `
        -userprincipalname $upn `
        -name $displayname `
        -displayname $displayname `
        -givenname $user.givenname `
        -surname $user.surname `
        -description $user.description `
        -Path "ou=Test OU,DC=testdomain,DC=com"` # Update to the correct OU and domain name for where your users will reside
        -accountpassword (convertto-securestring "34Temp12!" -asplaintext -force)`
        -changepasswordatlogon 1 `
        -enabled $true `
        -homedrive "Z" `
        -homedirectory "\\server\users\$accountName" # Update to your servers user folder address
 }
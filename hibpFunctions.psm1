<# 

.SYNOPSIS
Module for querying haveibeenpwned.com and pwnedpasswords

.DESCRIPTION
Follows the API functions as listed on https://haveibeenpwned.com/API/v3

#>

$hibpBaseURL = "https://haveibeenpwned.com/api/v3/"
$pwnedPasswordBaseURL = "https://api.pwnedpasswords.com/"

function Generate-HIBPHeaders 
{
    <#
    .SYNOPSIS
    Generate the headers used by all other functions in this module

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .EXAMPLE
    Generate-HIBPHeaders -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString"
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )

    $headers = @{
        'hibp-api-key' = $hibp_api_key
        'user-agent'   = $user_agent
    }

    return $headers
    
}
function Get-HIBPAllBreachesForAnAccount
{

    <#
    .SYNOPSIS
    Get all the breaches that a given account appears in.

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .PARAMETER account
    The email address that you want to search for. Not restricted to your monitored domains.

    .PARAMETER doNotTruncate
    Returns full results which includes details of the breach.

    .EXAMPLE
    Get-HIBPAllBreachesForAnAccount -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString" -account "your_email@example.com"

    #>
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent,
        [Parameter(Mandatory = $true, Position = 2)]
        [string] $account,
        [Parameter(Mandatory = $false)]
        [switch] $doNotTruncate
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "breachedaccount/" + [System.Web.HttpUtility]::UrlEncode($account)
    if ($doNotTruncate)
    {
        $url += "?truncateResponse=false"
    }

    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content | ConvertFrom-Json
        return $result
    }
    else
    {
        ("Error getting subscribed domains: {0}" -f $result.StatusCode) | Write-Error 
        return $result.StatusCode
    }
    
}

function Get-HIBPAllBreachesForADomain
{

    <#
    .SYNOPSIS
    Get all the breaches for a given domain. Must be a domain that you have validated ownership of through HIBP processes.

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .PARAMETER domain
    The domain that you want to get all the breaches for

    .NOTES
    This API call is rate limited more heavily than others. Don't send too often!

    .EXAMPLE
    Get-HIBPAllBreachesForADomain -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString" -domain "your.domain.example.com"
    
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent,
        [Parameter(Mandatory = $true, Position = 2)]
        [string] $domain
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "breacheddomain/" + $domain
    
    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content | ConvertFrom-Json
        return $result
    }
    else
    {
        ("Error getting all breaches for the domains: {0}" -f $result.StatusCode) | Write-Error
        return $result.StatusCode
    }

}

function Get-HIBPSubscribedDomains
{

    <#
    .SYNOPSIS
    Gets the details of the domains that your account is confirmed to monitored

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .EXAMPLE
    Get-HIBPSubscribedDomains -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString"
    
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )
    
    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "subscribeddomains"

    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content | ConvertFrom-Json
        return $result
    }
    else
    {
        ("Error getting subscribed domains: {0}" -f $result.StatusCode) | Write-Error
        return $result.StatusCode
    }
    # not doing any error checking here. Can be done in other code
    return $result
}

function Get-HIBPBreachedSites
{
    <#
    .SYNOPSIS
    Returns details of all the breaches that HIBP have on record (but not the account details)

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .EXAMPLE
    Get-HIBPBreachedSites -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString"
    
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "breaches"

    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content | ConvertFrom-Json
        return $result
    }
    else
    {
        ("Error getting subscribed domains: {0}" -f $result.StatusCode) | Write-Error
        return $result.StatusCode
    }
}

function Get-HIBPBreachedSite
{

    <#
    .SYNOPSIS
    Returns details of all the specified breach

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .PARAMETER breach
    The name of the breach that you want details on

    .EXAMPLE
    Get-HIBPBreachedSite -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString"
    
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent,
        [Parameter(Mandatory = $true, Position = 2)]
        [string] $breach
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "breach/" + $breach
    
    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content | ConvertFrom-Json
        return $result
    }
    else
    {
        ("Error getting subscribed domains: {0}" -f $result.StatusCode) | Write-Error
        return $result.StatusCode
    }
}

function Get-HIBPLatestBreach
{

    <#
    .SYNOPSIS
    Returns details of the latest breach that HIBP have released details on

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .EXAMPLE
    Get-HIBPLatestBreach -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString"
    
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "latestbreach"
    
    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content | ConvertFrom-Json
        return $result
    }
    else
    {
        ("Error getting subscribed domains: {0}" -f $result.StatusCode) | Write-Error
        return $result.StatusCode
    }
}

function Get-HIBPDataClasses
{

    <#
    .SYNOPSIS
    Returns details of the data classes that HIBP uses

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .EXAMPLE
    Get-HIBPDataClasses -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString"
    
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "dataclasses"
    
    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content | ConvertFrom-Json
        return $result
    }
    else
    {
        ("Error getting subscribed domains: {0}" -f $result.StatusCode) | Write-Error
        return $result.StatusCode
    }
}

function Get-HIBPAllPastesForAnAccount
{

    <#
    .SYNOPSIS
    Returns details of the paste dumps in which the specified account has appeared

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .PARAMETER account
    The email address that you want to search for

    .EXAMPLE
    Get-HIBPAllPastesForAnAccount -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString" -account "your_email@example.com"
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent,
        [Parameter(Mandatory = $true, Position = 2)]
        [string] $account
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "pasteaccount/" + [System.Web.HttpUtility]::UrlEncode($account)
    
    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content | ConvertFrom-Json
        return $result
    }
    else
    {
        ("Error getting subscribed domains: {0}" -f $result.StatusCode) | Write-Error
        return [int]$result.StatusCode
    }
    
}

function Get-HIBPSubscriptionStatus
{

    <#
    .SYNOPSIS
    Returns details of the subscription status

    .PARAMETER hibp_api_key
    The API key for your account

    .PARAMETER user_agent
    The user-agent string that you want to send to HIBP

    .EXAMPLE
    Get-HIBPSubscriptionStatus -hibp_api_key "putYourKeyHere" -user_agent "yourUserAgentString"
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "subscription/status"
    
    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content | ConvertFrom-Json
        return $result
    }
    else
    {
        ("Error getting subscribed domains: {0}" -f $result.StatusCode) | Write-Error
        return $result.StatusCode
    }
}

function Get-PwnedPassowrdsRange
{

    <#
    .SYNOPSIS
    Searches for password hashes that match the prefix you've specified

    .PARAMETER prefix
    The 5 character hex string that you want to use as the search prefix

    .PARAMETER ntlm
    Searches for NTLM hashes rather than SHA-1 hashes

    .EXAMPLE
    Get-PwnedPassowrdsRange -prefix "abc12"

    .NOTES
    This function does not output JSON or objects, it is a string of breaches. See https://haveibeenpwned.com/API/v3#PwnedPasswords for information.
    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $prefix,
        [Parameter(Mandatory = $false)]
        [switch] $ntlm
    )

    if ($prefix -notmatch '^[a-fA-F0-9]{5}$') # five hex characters
    {
        # prefix doesn't match what we're expecting. Print error
        ("Prefix doesn't match pattern expected") | Write-Error
        return -1
    }

    $url = $pwnedPasswordBaseURL + "range/" + $prefix

    if ($ntlm)
    {
        $url += "?mode=ntlm"
    }

    $headers = @{
        'Add-Padding' = $true
    }
    
    $result = Invoke-WebRequest -Uri $url -Headers $headers

    if ($result.StatusCode -eq 200)
    {
        $result = $result.content
        return $result
    }
    else
    {
        ("Error getting pwnd password range: {0}" -f $result.StatusCode) | Write-Error
        return [int]$result.StatusCode
    }
}

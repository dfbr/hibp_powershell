<# 

.SYNOPSIS
Module for querying haveibeenpwned.com and pwnedpasswords

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
    Generate-HIBPH
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
function Get-HIBPAllBreachesForAnAccount {
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

    $url = $hibpBaseURL + "breachedaccount/" + $account
    if ($doNotTruncate)
    {
        $url += "?truncateResponse=false"
    }
    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $Headers

    }

    $result = Invoke-restmethod @Params

    return $result
    
}

function Get-HIBPAllBreachesForADomain
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $domain
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "breacheddomain/" + $domain
    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $headers

    }

    $result = Invoke-restmethod @Params

    return $result
}

function Get-HIBPSubscribedDomains
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )
    
    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "subscribeddomains"
    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $headers
    }

    $result = Invoke-restmethod @Params

    # not doing any error checking here. Can be done in other code
    return $result
}

function Get-HIBPBreachedSites
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "breaches"
    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $Headers

    }

    $result = Invoke-restmethod @Params

    return $result
}

function Get-HIBPBreachedSite
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $breach
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "breach/" + $breach
    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $Headers

    }

    $result = Invoke-restmethod @Params

    return $result
}

function Get-HIBPLatestBreach
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "latestbreach"
    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $Headers

    }

    $result = Invoke-restmethod @Params

    return $result
}

function Get-HIBPDataClasses
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "dataclasses"
    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $Headers

    }

    $result = Invoke-restmethod @Params

    return $result
}

function Get-HIBPAllPastesForAnAccount
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $account
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "pasteaccount/" + [System.Web.HttpUtility]::UrlEncode($account)
    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $headers
    }

    $result = Invoke-restmethod @Params

    return $result
    
}

function Get-HIBPSubscriptionStatus
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $hibp_api_key,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $user_agent
    )

    $headers = Generate-HIBPHeaders -hibp_api_key $hibp_api_key -user_agent $user_agent

    $url = $hibpBaseURL + "subscription/status"
    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $Headers

    }

    $result = Invoke-restmethod @Params

    return $result
}

function Get-PwnedPassowrdsRange
{
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $prefix,
        [Parameter(Mandatory = $false)]
        [switch] $ntlm
    )

    if ($prefix -notmatch '^[a-fA-F0-9]{5}$') # five hex characters
    {
        # prefix doesn't match what we're expecting. Print error
        Write-host ("Prefix doesn't match pattern expected")
        exit
    }

    $url = $pwnedPasswordBaseURL + "range/" + $prefix

    if ($ntlm)
    {
        $url += "?mode=ntlm"
    }

    $headers = @{
        'Add-Padding' = $true
    }

    $Params = @{
        Method  = "Get"
        Uri     = $url
        Headers = $Headers

    }

    $result = Invoke-restmethod @Params

    return $result
}

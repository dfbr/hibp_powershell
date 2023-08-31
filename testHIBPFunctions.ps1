<#
.SYNOPSIS
Tests all functions in the HIBP function listed.

.NOTES
Only tests success, not failure.

#>

# import the HIBP functions
Import-Module ./hibpFunctions.psm1 -force -DisableNameChecking

# get the password and user string
$credentials = Import-Clixml ../authFiles/hibp.xml
$apiKey = $credentials.GetNetworkCredential().Password
$userAgent = $credentials.UserName


Write-Host ("Testing Get-HIBPAllBreachesForAnAccount")
$result = Get-HIBPAllBreachesForAnAccount -hibp_api_key $apiKey -user_agent $userAgent -account "test@example.com" 2>$null
if (($result -ne $null) -and ($result.gettype() -ne "Int32"))
{
    Write-Host "  Get-HIBPAllBreachesForAnAccount valid account test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPAllBreachesForAnAccount valid account test failed" -ForegroundColor Red
}
$result = Get-HIBPAllBreachesForAnAccount -hibp_api_key $apiKey -user_agent $userAgent -account "test@gmail.com1" 2>$null
if ($result -eq 404)
{
    Write-Host "  Get-HIBPAllBreachesForAnAccount invalid account test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPAllBreachesForAnAccount invalid account test failed" -ForegroundColor Red
}

# to avoid downloading the domain here, deliberatly testing an error case
# Write-Host ("Testing Get-HIBPAllBreachesForADomain")
# $result = Get-HIBPAllBreachesForADomain -hibp_api_key $apiKey -user_agent $userAgent -domain "example.com"

Write-Host ("Testing Get-HIBPSubscribedDomains")
$result = Get-HIBPSubscribedDomains -hibp_api_key $apiKey -user_agent $userAgent 2>$null
if (($result -ne $null) -and ($result.gettype() -ne "Int32"))
{
    Write-Host "  Get-HIBPSubscribedDomains test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPSubscribedDomains test failed" -ForegroundColor Red
}
$result = Get-HIBPSubscribedDomains -hibp_api_key "asdf" -user_agent $userAgent 2>$null
if ($result -eq 401)
{
    Write-Host "  Get-HIBPSubscribedDomains invalid API key test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPSubscribedDomains invalid API key test failed" -ForegroundColor Red
}

Write-Host ("Testing Get-HIBPBreachedSites")
$result = Get-HIBPBreachedSites -hibp_api_key $apiKey -user_agent $userAgent 2>$null
if (($result -ne $null) -and ($result.gettype() -ne "Int32"))
{
    Write-Host "  Get-HIBPBreachedSites test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPBreachedSites test failed" -ForegroundColor Red
}

Write-Host ("Testing Get-HIBPBreachedSite")
$result = Get-HIBPBreachedSite -hibp_api_key $apiKey -user_agent $userAgent -breach "Adobe" 2>$null
if (($result -ne $null) -and ($result.gettype() -ne "Int32"))
{
    Write-Host "  Get-HIBPBreachedSite valid breach test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPBreachedSite valid breach test failed" -ForegroundColor Red
}
$result = Get-HIBPBreachedSite -hibp_api_key $apiKey -user_agent $userAgent -breach "funkadelic" 2>$null
if ($result -eq 404)
{
    Write-Host "  Get-HIBPBreachedSite invalid breach test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPBreachedSite invalid breach test failed" -ForegroundColor Red
}

Write-Host ("Testing Get-HIBPLatestBreach")
$result = Get-HIBPLatestBreach -hibp_api_key $apiKey -user_agent $userAgent 2>$null
if (($result -ne $null) -and ($result.gettype() -ne "Int32"))
{
    Write-Host "  Get-HIBPLatestBreach test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPLatestBreach test failed" -ForegroundColor Red
}

Write-Host ("Testing Get-HIBPDataClasses")
$result = Get-HIBPDataClasses -hibp_api_key $apiKey -user_agent $userAgent
if (($result -ne $null) -and ($result.gettype() -ne "Int32"))
{
    Write-Host "  Get-HIBPDataClasses test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPDataClasses test failed" -ForegroundColor Red
}

Write-Host ("Testing Get-HIBPAllPastesForAnAccount")
$result = Get-HIBPAllPastesForAnAccount -hibp_api_key $apiKey -user_agent $userAgent -account "security@gmail.com"
if (($result -ne $null) -and ($result.gettype() -ne "Int32"))
{
    Write-Host "  Get-HIBPAllPastesForAnAccount valid account test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPAllPastesForAnAccount valid account test failed" -ForegroundColor Red
}
$result = Get-HIBPAllPastesForAnAccount -hibp_api_key $apiKey -user_agent $userAgent -account "security@gmail.com1" 2>$null
if ($result -eq 404)
{
    Write-Host "  Get-HIBPAllPastesForAnAccount invalid account test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPAllPastesForAnAccount invalid account test failed" -ForegroundColor Red
}

Write-Host ("Testing Get-HIBPSubscriptionStatus")
$result = Get-HIBPSubscriptionStatus -hibp_api_key $apiKey -user_agent $userAgent
if (($result -ne $null) -and ($result.gettype() -ne "Int32"))
{
    Write-Host "  Get-HIBPSubscriptionStatus valid account test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPSubscriptionStatus valid account test failed" -ForegroundColor Red
}
$result = Get-HIBPSubscriptionStatus -hibp_api_key "asdfasdf" -user_agent $userAgent 2>$null
if ($result -eq 401)
{
    Write-Host "  Get-HIBPSubscriptionStatus invalid account test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-HIBPSubscriptionStatus invalid account test failed" -ForegroundColor Red
}

Write-Host ("Testing Get-PwnedPassowrdsRange")
$result = Get-PwnedPassowrdsRange -prefix "abc12"
if (($result -ne $null) -and ($result.gettype() -ne "Int32"))
{
    Write-Host "  Get-PwnedPassowrdsRange valid prefix test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-PwnedPassowrdsRange valid prefix test failed" -ForegroundColor Red
}
$result = Get-PwnedPassowrdsRange -prefix "abR12" 2>$null
if ($result -eq -1)
{
    Write-Host "  Get-PwnedPassowrdsRange invalid prefix test passed" -ForegroundColor Green
}
else {
    Write-Host "   Get-PwnedPassowrdsRange invalid prefix test failed" -ForegroundColor Red
}

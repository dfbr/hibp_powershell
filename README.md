# hibp_powershell
Powershell functions for querying the HaveIBeenPwned v3 API

Follows the specification at https://haveibeenpwned.com/API/v3 but encapsulated in Powershell functions.

You'll need:

- A valid API key (See https://haveibeenpwned.com/API/Key)
- Powershell v7 (probably trivial to make this work on Powershell 5 but this is an initial version. Submit request if this is important to you)

## Installation

Just copy the file `hibpFunctions.psm1` to a convenient location either directly or through a clone.

## Usage

See examples in each function, but broadly:

-   `name-of-function -hibp_api_key $yourKeyHere -user_agent "your_user_agent_name"` along with any other parameters specified by the function

## Response codes

The functions do nothing to validate the response or amend the response from HIBP. You can see the response codes here:
| Code |	Description |
| 200 |	Ok — everything worked and there's a string array of pwned sites for the account |
| 400 |	Bad request — the account does not comply with an acceptable format (i.e. it's an empty string) |
| 401 |	Unauthorised — either no API key was provided or it wasn't valid |
| 403 |	Forbidden — no user agent has been specified in the request |
| 404 |	Not found — the account could not be found and has therefore not been pwned |
| 429 |	Too many requests — the rate limit has been exceeded |
| 503 |	Service unavailable — usually returned by Cloudflare if the underlying service is not available  |

## Note on API Key storage

Of course it's recommended not to store the API key in plaintext. You could do something like this:
- `Get-Credential | Export-Clixml hibp.xml` with the user agent as the username and the API key as the password.
- To retrieve it's
  - `$credentials = Import-Clixml hibp.xml`
  - `$userAgent = $credentials.username`
  - `$apiKey = $credentials.GetNetworkCredential().password`

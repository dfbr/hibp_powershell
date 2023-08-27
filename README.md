# hibp_powershell
Powershell functions for querying HaveIBeenPwned

Follows the specification at https://haveibeenpwned.com/API/v3 but encapsulated in Powershell functions.

You'll need:

- A valid API key (See https://haveibeenpwned.com/API/Key)
- Powershell v7 (probably trivial to make this work on Powershell 5 but this is an initial version. Submit request if this is important to you)

## Installation

Just copy the file `hibpFunctions.psm1` to a convenient location either directly or through a clone.

## Usage

See examples in each function, but broadly:

-   `name-of-function -hibp_api_key $yourKeyHere -user_agent "your_user_agent_name"` along with any other parameters specified by the function

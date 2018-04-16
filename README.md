This script makes it easier to switch between multiple AWS accounts that require MFA authentication when using the AWS CLI.

Steps:
- Install [jq](https://stedolan.github.io/jq/download/) if you don't already have it
- Put your [Named AWS Profile(s)](https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html) in place with AWS API credentials having sufficient permissions to interact with AWS STS (note: use underscores instead of dashes in your profile names)
- copy aws_cli_mfa_auth.sh in your working directory
- setup aws_mfa_accounts.json in your working directory, with the following structure, filling out details for each mfa account you wish to access:

```
{
  "aws_cli_profile_name": "arn:aws:iam::12345:mfa/username"
}
```
Note - each key must be the same name as an existing profile in your .aws/credentials file. This script currently does not support dashes in the profile name, so snake or camel case is required.

- open your MFA device to get the MFA code
- `source aws_cli_mfa_auth.sh <profile> <MFA Code>` # use source instead of executing it directly since it exports environmental variables
- confirm successful authentication by running `aws sts get-caller-identity`

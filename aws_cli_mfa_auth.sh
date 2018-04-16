# Before running this script, you should already have jq installed, an aws profile in your .aws/credentials with sufficient permissions to interact with AWS STS, an MFA device configured for that account in IAM, and a local aws_mfa_accounts.json file with the following structure, filling out details for each mfa account you wish to access:
# {
#   "client1 tag": "mfa_arn1",
#   "ae_produat": "arn:aws:iam::12345:mfa/username"
# }

# Usage: source aws_cli_mfa_auth.sh <aws_profile> <mfa_code>

#!/bin/bash

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

AWS_PROFILE=$1
MFA_CODE=$2

# lookup the AWS_PROFILE in the json to get the serial number
MFA_ARN=$(cat aws_mfa_accounts.json | jq -r ."$AWS_PROFILE")

# get the session credentials from aws
SESSION=$(aws sts get-session-token \
  --profile $AWS_PROFILE \
  --serial-number $MFA_ARN \
  --duration-seconds 3600 \
  --token-code $MFA_CODE \
  --output json \
  | jq ."Credentials")

export AWS_ACCESS_KEY_ID=$(echo $SESSION | jq -r '.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $SESSION | jq -r '.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $SESSION | jq -r '.SessionToken')

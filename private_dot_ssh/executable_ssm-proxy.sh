#!/usr/bin/env sh
#################################################
# Usage
#################################################
# ssh ec2-user@ip-x.x.x.x,eu-west-1,default
# scp foo ec2-user@i-xxx,eu-west-1,default:/tmp/
#################################################
set -eu

ID="$1"
SSH_USER="$2"
SSH_PORT="$3"
SSH_PUBLIC_KEY_PATH="$4"
SSH_PUBLIC_KEY="$(cat "${SSH_PUBLIC_KEY_PATH}")"
SSH_PUBLIC_KEY_TIMEOUT=60

# Set dot as delimiter
IFS=','

# Remove ip- prefix
ID=${ID#"ip-"}

if echo "${ID}" | grep -qe "${IFS}"
then
    read -a CREDENTIALS <<< "${ID}"
    ID="${CREDENTIALS[0]}"
    export AWS_DEFAULT_REGION="${CREDENTIALS[1]}"
    export AWS_PROFILE="${CREDENTIALS[2]}"
fi

#################################################
# Get private IP address
#################################################

IPV4_PATTERN="([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})"
if [[ ${ID} =~ ${IPV4_PATTERN} ]]; then
    ID=$(aws ec2 describe-instances \
        --filters "Name=private-ip-address,Values=${ID}" \
        --query 'Reservations[0].Instances[0].InstanceId' \
        --output text \
        --region ${AWS_DEFAULT_REGION} \
        --profile ${AWS_PROFILE})
fi

#################################################
# Add public key to instance
#################################################

>/dev/stderr echo "Auth: ${SSH_USER}@${ID} ${AWS_DEFAULT_REGION} ${AWS_PROFILE}"

aws ssm send-command \
  --instance-ids "${ID}" \
  --document-name 'AWS-RunShellScript' \
  --comment "Add an SSH public key to authorized_keys for ${SSH_PUBLIC_KEY_TIMEOUT} seconds" \
  --parameters commands="\"
    mkdir -p ~${SSH_USER}/.ssh && cd ~${SSH_USER}/.ssh || exit 1
    authorized_key='${SSH_PUBLIC_KEY} ssm-session'
    echo \\\"\${authorized_key}\\\" >> authorized_keys
    sleep ${SSH_PUBLIC_KEY_TIMEOUT}
    grep -v -F \\\"\${authorized_key}\\\" authorized_keys > .authorized_keys
    mv .authorized_keys authorized_keys
  \""

#################################################
# Start ssm session to instance
#################################################

>/dev/stderr echo "Starting session ..."

aws ssm start-session \
  --target "${ID}" \
  --document-name 'AWS-StartSSHSession' \
  --parameters "portNumber=${SSH_PORT}"

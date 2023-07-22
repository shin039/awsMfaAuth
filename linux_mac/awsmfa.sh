#!/bin/bash

# ------------------------------------------------------------------------------
# Check Args
# ------------------------------------------------------------------------------
if [ $# -ne 1 ];then
  echo "第一引数にトークンコードを指定してください"
  exit 1;
fi

# ------------------------------------------------------------------------------
# Settings
# ------------------------------------------------------------------------------
mfa_serial="Set Your Mfa Devices ARN"
profile_name="Set Your Profile Name"
awscli_args="Set Aws Cli Args"

# ------------------------------------------------------------------------------
# Statics
# ------------------------------------------------------------------------------
tokencode="$1"
tmpfile=`mktemp`

dir_baseConf=`dirname $0`"/base_configs"
credentials=~/.aws/credentials

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

# Fetch AWS
aws ${awscli_args} sts get-session-token --serial-number  ${mfa_serial} --token-code "${tokencode}" > ${tmpfile}

if [ $? -ne 0 ];then 
  if [ -e ${tmpfile} ];then rm ${tmpfile}; fi
  exit 1;
fi

# Create credentials file by profile
accessKeyId=`cat ${tmpfile}     | jq -r .Credentials.AccessKeyId`
secretAccessKey=`cat ${tmpfile} | jq -r .Credentials.SecretAccessKey`
sessionToken=`cat ${tmpfile}    | jq -r .Credentials.SessionToken`

echo ""                                           >  ${dir_baseConf}/${profile_name}
echo "# ----------------------------------------" >> ${dir_baseConf}/${profile_name}
echo "# ${profile_name}"                          >> ${dir_baseConf}/${profile_name}
echo "# ----------------------------------------" >> ${dir_baseConf}/${profile_name}
echo "[${profile_name}]"                          >> ${dir_baseConf}/${profile_name}
echo "aws_access_key_id     = ${accessKeyId}"     >> ${dir_baseConf}/${profile_name}
echo "aws_secret_access_key = ${secretAccessKey}" >> ${dir_baseConf}/${profile_name}
echo "aws_session_token     = ${sessionToken}"    >> ${dir_baseConf}/${profile_name}
echo ""                                           >> ${dir_baseConf}/${profile_name}

# Delete Tempfile
if [ -e ${tmpfile} ];then rm ${tmpfile}; fi

# Backup credentials
# バックアップ履歴を撮っておきたい時
# if [ -e ${credentials} ]; then cp ${credentials} ${credentials}.`date "+%Y%m%d%H%M%S"`; fi
# 直前のバックアップだけでいい時
if [ -e ${credentials} ]; then cp ${credentials} ${credentials}.autobackup; fi

# Create credentials
cat ${dir_baseConf}/* > ${credentials}


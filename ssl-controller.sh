#!/bin/bash
# Everything below will go to the file 'ssl.log':
LOG_PATH=`dirname "$0"`"/ssl.log"
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>$LOG_PATH 2>&1

echo "---------------  ssl control  --------------- $(date +%d/%m)"

INI_PATH=`dirname "$0"`"/config.ini"
if [ ! -f "$INI_PATH" ]; then
  echo "error: config.ini doesn't exist"
  exit;
fi

# get config params
SMS_LINK=$(awk -F "=" '/SMS_LINK/ {print $2"="$3"="$4"="}' $INI_PATH)
SITE_LIST=$(awk -F "=" '/SITE_LIST/ {print $2}' $INI_PATH)

# create site array
IFS=',' read -r -a array <<< "$SITE_LIST"

# for each site check ssl and send sms if no ssl
for i in "${array[@]}"
do
	if true | openssl s_client -connect $i:443 2>/dev/null | openssl x509 -noout -checkend 0; then
    echo " - $i - Certificate is not expired"
  else
    echo " - $i - Certificate is expired"
    curl -i "$SMS_LINK - $i - Certificate is expired"
  fi
done
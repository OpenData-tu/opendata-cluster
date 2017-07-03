#!/bin/bash
source  ./scripts/colors.sh

API_DOMAIN=api.${NAME}
echo -n "Waiting for DNS to update! ${API_DOMAIN}:"
while [ ture ]
do
  ip=$(dig $API_DOMAIN +short | head -1)
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    break;
  fi
  printf "."
  sleep 1
done
cecho "OK!" green

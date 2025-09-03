#!/bin/bash

# Source: https://gist.github.com/Geofferey/e3c49d195a01229e61b878f4530bd052

TS_CIDR="100.64.0.0/10"
HEADSCALE_DB=~/docker/headscale/data/db.sqlite

if [ -z ${1} ] || [ -z ${2} ] && [[ ${1} != "list" ]]; then

 echo
 echo "    quick use: ${0} hostname newip"
 echo
 echo "    e.g. ${0} Win10-Wrksta 100.64.0.2 (case censitive)"
 echo "    e.g. ${0} list"
 echo

fi

if [ -z ${1} ]; then

  read -p "Enter the hostname of the headscale node you wish to change IP for: " HOST_NAME
  echo

else

  HOST_NAME=${1}

fi

if [ ${1} = list ]; then

  echo
  sqlite3 $HEADSCALE_DB "SELECT Hostname,Ipv4 FROM nodes"
  echo
  exit

fi

CHK_NODE=$(sqlite3 $HEADSCALE_DB "SELECT Hostname FROM nodes where Hostname = '${HOST_NAME}'")

if ! [ ${CHK_NODE} ]; then

  echo
  echo "Node ${HOST_NAME} not found in table..."
  echo
  exit

fi

if [ -z ${2} ]; then

  read -p "Enter the IP you wish to assign to your headscale node: " NEW_IP

else

  NEW_IP=${2}

fi

LANG=C

## Stolen from https://stackoverflow.com/questions/13777387/check-for-ip-validity
TMP="${NEW_IP}" # <-- your string in input
IP="$TMP"
CHECK=""
I=4
while [ $I -ne 0 ]; do

    I=$(( $I - 1 ))
    J="${TMP%%.*}"
    K="${J#[0-9]}"
    K="${K#[0-9]}"
    K="${K#[0-9]}"

    if [ "$J" != "$K" ] && [ -z "$K" ] && [ "$J" -ge 0 ] && [ "$J" -le 255 ]; then
        CHECK="$CHECK.$(( $J ))"
    fi

    TMP="${TMP#*.}"

done

CHECK="${CHECK#.}"

echo

if [ -n "$IP" ] && [ "$IP" != "$CHECK" ]; then

    echo "'$IP' appears to be an invalid IP" # input is from 0.0.0.0 to 255.255.255.255
    echo
    echo "...quitting!..."
    echo
    exit

fi

## Lifted from https://serverfault.com/a/1165239/475457
function is_ip_in_cidr()
{
    local ip=$1
    local cidr=$2

    #Process the CIDR first
    local network=$(echo $cidr | cut -d/ -f1)
    local mask=$(echo $cidr | cut -d/ -f2)

    #Quad dot notation has 4 fields. Shift and add to give decimal number
    local network_dec=$(echo $network | awk -F. '{printf("%d\n", (($1 * 256 +$2) * 256 + $3) * 256 + $4) }')
    #TEST echo "network_dec: $network_dec"

    #Shift bitmask correct number of places for given mask
    local mask_dec=$((0xffffffff << (32 - $mask)))

    #TEST local mask_dec=$((0x0000000f << (32 - $mask)))
    #TEST printf "mask_dec: %x\n", $mask_dec

    #But limit bitmask to 32 bits or 8 hexidecimal places.
    local mask_dec2=$((0xffffffff & $mask_dec))
    #TEST printf "mask_dec2: %x\n", $mask_dec2

    #Apply mask to network address to get the bits to check
    local net1=$(( $mask_dec2 & $network_dec ))
    #TEST printf "net1: %x\n", $net1

    #Process the IP address. Again Quad dot notation, shift and add.
    local ip_dec=$(echo $ip | awk -F. '{printf("%d\n", (($1 * 256 +$2) * 256 + $3) * 256 + $4) }')
    #TEST echo "IP DEC: $ip_dec"

    #Apply the same mask to IP address
    local net2=$(( $mask_dec2 & $ip_dec ))
    #TEST printf "net2: %x\n", $net2

    #Now the two network components can be compared
    if [[ $net1 == $net2 ]]; then
        return 0
    else
        return 1
    fi
}

# Abuse the function with a sample IP address and CIDR
ip=${IP}
cidr=${TS_CIDR}

if ! $(is_ip_in_cidr $ip $cidr); then

    echo "IP is not in ${TS_CIDR} subnet"
    echo
    echo "...quitting!..."
    echo
    exit

fi

CHK_NODE_IP=$(sqlite3 $HEADSCALE_DB "SELECT ipv4 FROM nodes where ipv4 = '${NEW_IP}'")

if ! [ -z ${CHK_NODE_IP} ]; then

  IP_HOLDER=$(sqlite3 $HEADSCALE_DB "SELECT Hostname FROM nodes where ipv4 = '${NEW_IP}'")

  echo "Chosen IP is currently in use by ${IP_HOLDER}, try with a different IP or fandangle em around..."
  echo
  exit 0

fi

if $(sqlite3 ${HEADSCALE_DB} "update nodes set ipv4 = '$NEW_IP' where Hostname = '${HOST_NAME}'"); then

  echo "Node IP update successful..."

fi

echo

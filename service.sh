#!/bin/bash


INTERFACES=("eth0,192.168.0.1" "wlx1cbfce395c55,192.168.0.1")
# interface,defaultgw

PING_ADDRESS=192.168.0.1
# ideally the next hop in routing

COOLDOWN=30
DIR="$(dirname "$(realpath "$0")")"


while true
do 
    CURRENT_INTERFACE=$(echo $(ip -4 route show default) | cut -d " " -f 5)
    if [[ $($DIR/check_up.sh $CURRENT_INTERFACE $PING_ADDRESS) != 0 ]]; then
      CURRENT_INTERFACE=$(echo $(ip -4 route show default) | cut -d " " -f 5)
      for i in "${!INTERFACES[@]}"
      do
         if [[ $(echo "${INTERFACES[$i]}" | awk -F, '{for (i=1;i<=NF;i++)print $i}' | head -1) != $CURRENT_INTERFACE ]]; then
           SWITCH_INTERFACE=$(echo "${INTERFACES[$i]}" | awk -F, '{for (i=1;i<=NF;i++)print $i}' | tail -1)
           SWITCH_GATEWAY=$(echo "${INTERFACES[$i]}" | awk -F, '{for (i=1;i<=NF;i++)print $i}' | head -1)
           break
         fi
      done
      echo "SWITCH INTERFACE IS... $SWITCH_INTERFACE"
      echo "SWITCH GATEWAY IS... $SWITCH_GATEWAY"
      $DIR/switch_interface.sh $SWITCH_INTERFACE $SWITCH_GATEWAY
    fi
    sleep $COOLDOWN
done


#!/bin/bash
echo ""
echo "----------------------------------------------------------"
printf -v DATE '%(%F)T' -1
echo "[${DATE}] Start Operation Restarting Servers"
echo "----------------------------------------------------------"
# IP adress without separator -> Curl IW4Madmin (Exemple: 127001)
ipadress="YOURIPADRESS"
## -- Zombies Servers -- ##
# Number of running servers
server_number=$(ps aux | grep t6zm | grep -v grep |  wc -l)
servers=$(ps aux | grep t6zm | grep -v grep)
for ((i=1; i<=$server_number; i++))
  do
    # Get PID process
    process=$(echo "$servers"  | sed -n "${i}p")
    PID=$(echo "$process" | awk  '{print $2}')
    # Server port listening
    port=$(echo "$process" | awk  '{print $21}' | sed -n '1p')
    # CFG Name
    name=$(echo "$process" | awk  '{print $24}' | sed -n '1p' | cut -d '.' -f1)
    # Number of client connected on the server # IW4Madmin Required
    connected_client=$(curl -X GET "http://localhost:1624/server/clientactivity/${ipadress}${port}" 2>/dev/null | sed -n '/href="/,/a>/p' | grep 'ColorCode' | cut -d '>' -f2 | cut -d '<' -f1 | wc -l)
    # Kill Process if 0 client are connected
    if [[ "$connected_client" == "0" ]]; then
      kill -9 "${PID}" 2> /dev/null
      printf -v NOW '%(%H:%M:%S)T' -1
      echo "[${NOW}] Zombies Server [ ${name} ] Restarting..."
    else
      printf -v NOW '%(%H:%M:%S)T' -1
      echo "[${NOW}] Zombies Server [ ${name} ] have ${connected_client} clients online"
    fi
  done

## -- Multiplayers Servers -- ##
# Number of running servers
server_number=$(ps aux | grep t6mp | grep -v grep |  wc -l)
servers=$(ps aux | grep t6mp | grep -v grep)
for ((i=1; i<=$server_number; i++))
  do
    # Get PID process
    process=$(echo "$servers"  | sed -n "${i}p")
    PID=$(echo "$process" | awk  '{print $2}')
    # Server port listening
    port=$(echo "$process" | awk  '{print $21}' | sed -n '1p')
    # CFG Name
    name=$(echo "$process" | awk  '{print $24}' | sed -n '1p' | cut -d '.' -f1)
    # Number of client connected on the server # IW4Madmin Required
    connected_client=$(curl -X GET "http://localhost:1624/server/clientactivity/${ipadress}${port}" 2>/dev/null | sed -n '/href="/,/a>/p' | grep 'ColorCode' | cut -d '>' -f2 | cut -d '<' -f1 | wc -l)
    # Kill Process if 0 client are connected
    if [[ "$connected_client" == "0" ]]; then
      kill -9 "${PID}" 2> /dev/null
      printf -v NOW '%(%H:%M:%S)T' -1
      echo "[${NOW}] Multiplayers Server [ ${name} ] Restarting..."
    else
      printf -v NOW '%(%H:%M:%S)T' -1
      echo "[${NOW}] Multiplayers Server [ ${name} ] have ${connected_client} clients online"
    fi
  done
echo "----------------------------------------------------------"
echo ""
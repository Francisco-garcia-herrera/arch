#!/bin/bash


ctrl_c (){
  echo -e "\n\n[!]Saliendo...\n"
  exit 1
}


trap ctrl_c INT


for i in $(seq 1 254); do
  timeout 1 bash -c "ping -c 1 192.168.1.$i &>/dev/null" && echo "[+]Host 192.168.1.$i is ACTIVE" &
done; wait

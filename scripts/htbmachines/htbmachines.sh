#!/bin/bash

source list-generator.sh

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


#Variables globales
main_url="https://htbmachines.github.io/bundle.js"

#Ctrl_c
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}";
  tput cnorm && exit 1
}

function checkConnection(){
  ping -c 2 8.8.8.8 &>/dev/null
  if [ $? -ne 0 ]; then
    echo -e "\n\t${redColour}[!]${endColour} Sin conexión a internet, cerrando la aplicación...";
    tput cnorm && exit 1
  fi
}

function helpPanel (){
  tput civis
  echo -e "\nPanel de Ayuda"
  echo -e "${yellowColour}[+]${endColour}${grayColour}Uso:${endColour}"
  echo -e "\t ${purpleColour}-u)${endColour} Actualizar listado de máquinas"
  echo -e "\t ${purpleColour}-m)${endColour} Buscar por nombre de una máquina"
  echo -e "\t ${purpleColour}-h)${endColour} Mostrar este panel de ayuda"
  tput cnorm
}

function update(){
  tput civis
  
  checkConnection

  if [ ! -f bundle.js ]; then
    echo -e "\t[+] Descargando lista de máquinas Hack The Box..."
    sleep 1
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\t[+] Descarga finalizada."
    generateList
  else
    echo -e "\t[+] Comprobando actualizaciones..."
    sleep 2
    curl -s $main_url > bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    
    md5BundleTemp=$(md5sum bundle_temp.js | awk '{print $1}')
    md5Bundle=$(md5sum bundle.js | awk '{print $1}')

    if [ "$md5BundleTemp" == "$md5Bundle" ]; then
      echo -e "\t[+] Los datos están actualizados."
      rm bundle_temp.js
    else
      echo -e "\t[!] Aplicando actualización..."
      mv bundle_temp.js bundle.js
      sleep 2
      echo -e "\t${greenColour}[+]${endColour}Datos actualizados correctamente."
      generateList
    fi
  fi
  tput cnorm
}

function searchMachine(){
  tput civis

  if [ ! -f bundle.js ]; then
    echo -e "\n\t[!] No exite el fichero de datos bundle.js.\n"
    update
  fi
  machineChecker=$(cat listHtbmachines.json | awk "/\"name\": \"$1\"/,/\"youtube\":/")
  #echo "$machineChecker"
  if [[ -z "$machineChecker" ]]; then
    echo -e "\n\t[!] La máquina no existe."
  else
    cat listHtbmachines.json | awk "/\"name\": \"$1\"/,/\"youtube\":/" | tr -d '"' | tr -d ','
  fi
  tput cnorm
}

function searchDificulty(){
  tput civis

    cat listHtbmachines.json | grep "\"dificultad\": \"$1\"" -A 3 -B 3 | grep -vE "skills|so|ip|like|dificultad" | column
    echo -e "\n$(cat listHtbmachines.json | grep "\"dificultad\": \"$1\"" | wc -l)" "máquinas encontradas"
    
  tput cnorm
}

declare -i parameter_counter=0

trap ctrl_c INT

#Check if bundle_temp.js exist and delete it.
if [ -f bundle_temp.js ]; then
  rm bundle_temp.js
fi

while getopts "dFMDIm:uh" arg; do
  case $arg in
    d) let parameter_counter+=4;;
    F) let parameter_counter+=6;;
    M) let parameter_counter+=8;;
    D) let parameter_counter+=10;;
    I) let parameter_counter+=12;;
    m) machineName=$OPTARG;let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  update
elif [ $parameter_counter -eq 3 ]; then
  update
  searchMachine $machineName
elif [ $parameter_counter -eq 10 ]; then
  searchDificulty "Fácil"
elif [ $parameter_counter -eq 12 ]; then
  searchDificulty "Media"
elif [ $parameter_counter -eq 14 ]; then
  searchDificulty "Difícil"
elif [ $parameter_counter -eq 16 ]; then
  searchDificulty "Insane"
else
 helpPanel
fi

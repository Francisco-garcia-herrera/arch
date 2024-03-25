#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Ctrl_c
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}";
  tput cnorm && exit 1
}

function helpPanel (){
  tput civis
  echo -e "\nPanel de Ayuda"
  echo -e "${yellowColour}[+]${endColour}${grayColour}Uso:${endColour}"
  echo -e "\t ${purpleColour}-m)${endColour} Money: Cantidad de dinero con la empiezas a jugar."
  echo -e "\t ${purpleColour}-t)${endColour} Technique: Técnica usada en el juego. (${yellowColour}martingala${endColour} / ${yellowColour}inverseLabrouchere${endColour})"
  echo -e "\t ${purpleColour}-h)${endColour} Mostrar este panel de ayuda."
  tput cnorm && exit 1
}

function printParImpar(){
  if [[ "$1 % 2" -eq 0 ]]; then
    echo -n -e "\t${greenColour}par${endColour}"
  else
    echo -n -e "\t${redColour}impar${endColour}"
  fi
}

function getParImpar(){
  if [[ "$1 % 2" -eq 0 ]]; then
    echo "par"
  else
    echo "impar"
  fi
}

function checkGame(){
  if [[ "$2" -gt 0 ]]; then
    result=$(getParImpar $2)
    if [[ "$1" == "$result" ]]; then
      money=$(($money+(bet*2)))
      bet=$initial_bet
      let malaRacha=0
      cadena=()
      # echo -n -e "\t${greenColour}Has ganado!!!${endColour}"
    else
      bet=$(($bet*2))
      let malaRacha+=1
      cadena+=("$2")
      # echo -n -e "\t${redColour}Has perdido ;( ${endColour}"
    fi  
  else
    bet=$(($bet*2))
    let malaRacha+=1
    cadena+=("$2")
    # echo -n -e "\t${redColour}Has perdido ;( ${endColour}"
  fi
 
}

function martingala(){
  echo -e "\n\t[+] Técnica seleccionada ${yellowColour}martingala${endColour}"
  echo -e "\t[+] Dinero actual: ${yellowColour}$money €${endColour}"
  echo -n -e "\t¿Cuando dinero quieres apostar? -> " && read initial_bet
  echo -n -e "\t¿A qué deseas apostar continuamente? (${blueColour}par${endColour} / ${blueColour}impar${endColour}) -> " && read par_impar

  echo -e "\tVamos a jugar con la cantidad de ${yellowColour}$initial_bet€${endColour} a ${yellowColour}$par_impar${endColour}\n"

  bet=$initial_bet
  gameCounter=0
  malaRacha=0
  maxMoney=$money
  declare -a cadena=()

  tput civis
  while [[ $money -gt 0 ]]; do
    money=$(($money-$bet))
    # echo -e "\tApuesta de $bet€ , Saldo actual: $money"
    random_number="$(($RANDOM % 37))"
    # echo -n -e "\t[*] Ha salido el número: ${blueColour}$random_number${endColour}";printParImpar $random_number ;checkGame $par_impar $random_number;echo -n -e "\tSaldo Actual : $money"
    checkGame $par_impar $random_number
    # echo -e "\n"

    if [[ "$money" -gt "$maxMoney" ]]; then
      maxMoney=$money
    fi
    if [[ "$bet" -gt "$money" ]]; then
      bet=$money
    fi
    let gameCounter+=1
    #sleep 2
  done
  echo -e "\t${redColour}[!] Saldo $money€${endColour}" "\tNúmero de jugadas: ${blueColour}$gameCounter${endColour}" "\tPeor racha: ${redColour}$malaRacha${endColour}" "\tMax Money: $maxMoney€";

  echo -e -n "\t["
  for number in ${cadena[@]}; do
    echo -n -e " ${purpleColour}$number${endColour} "
  done;
  echo -n "]"
  echo "";
  tput cnorm; exit 0
}

trap ctrl_c INT

declare -i parameter_counter=0
declare -i bet=0

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala $money
  else
    echo -e "La técnica seleccionada no existe.";
    helpPanel
  fi
else
 helpPanel
fi

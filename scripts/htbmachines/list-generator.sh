#!/bin/bash
function generateList(){
  tput civis
  bloqueMachine=""
  bloqueJSON=""
  declare -i machineCounter=0

  # if [[ -f listHtbmachines ]]; then
    # rm listHtbmachines
  # fi
  if [[ -f listHtbmachines.json ]]; then
    rm listHtbmachines.json
  fi
  echo -e "[" >> listHtbmachines.json
  
  echo -e "\t[+] Generando archivo listHtbmachines.json ..."
  echo -n -e "\t[!] Máquinas encontradas 0"
  # Usamos awk para buscar los bloques y luego iterar sobre ellos
  awk '/lf =|lf.push/ {
      in_block = 1  # Establecemos la bandera para indicar que estamos dentro de un bloque
      next  # Pasamos a la siguiente línea
  }
  /resuelta/ {
      in_block = 0  # Restablecemos la bandera al salir del bloque
  }
  in_block {  # Si estamos dentro de un bloque, imprimimos la línea
      print $0
  }' bundle.js | while IFS= read -r linea; do
      # Aquí puedes realizar cualquier acción con la línea procesada
      clean_line="$(echo ${linea%?} | sed 's/^[[:space:]]+//')"
      clean_line_f="$(echo $clean_line | awk -F': ' '{print $1}')"
      clean_line_e="$(echo $clean_line | awk -F': ' '{print $2, $3}')"

      if [[ "$clean_line_f" = "name" ]]; then
        # bloqueMachine+="$clean_line\n"
        bloqueJSON+="\"$clean_line_f\": $clean_line_e,\n"
      fi
      
      if [[ "$clean_line_f" = "ip" ]]; then
        # bloqueMachine+="$clean_line\n"
        bloqueJSON+="\"$clean_line_f\": $clean_line_e,\n"
      fi

      if [[ "$clean_line_f" = "so" ]]; then
        # bloqueMachine+="$clean_line\n"
        bloqueJSON+="\"$clean_line_f\": $clean_line_e,\n"
      fi
      
      if [[ "$clean_line_f" = "dificultad" ]]; then
        # bloqueMachine+="$clean_line\n"
        bloqueJSON+="\"$clean_line_f\": $clean_line_e,\n"
      fi

      if [[ "$clean_line_f" = "skills" ]]; then
        # bloqueMachine+="$clean_line\n"
        bloqueJSON+="\"$clean_line_f\": $clean_line_e,\n"
      fi

      if [[ "$clean_line_f" = "like" ]]; then
        # bloqueMachine+="$clean_line\n"
        bloqueJSON+="\"$clean_line_f\": $clean_line_e,\n"
      fi

      if [[ "$clean_line_f" = "youtube" ]]; then
        # bloqueMachine+="$clean_line"
        bloqueJSON+="\"$clean_line_f\": $clean_line_e"
      fi
      
      if [[ "$clean_line_f" = "youtube" ]]; then
        #echo "/////////////////////"
        #echo -e "$bloqueMachine"
        #echo "/////////////////////"
        # echo -e "{\n"
        # echo -e $bloqueJSON
        # echo -e "}\n"
        if [[ $machineCounter -ne 0 ]]; then
          echo -e "," >> listHtbmachines.json
        fi
        # echo -e "machine:" >> listHtbmachines
        # echo -e "$bloqueMachine" >> listHtbmachines
        # echo -e "machine!" >> listHtbmachines
        
        echo -e "{" >> listHtbmachines.json
        echo -e "$bloqueJSON" >> listHtbmachines.json
        echo -e "}" >> listHtbmachines.json
        
        bloqueMachine=""
        bloqueJSON=""
        machineCounter+=1
        echo -en "\r\t[!] Máquinas encontradas $machineCounter"
      fi
  done
  echo -e "]" >> listHtbmachines.json
  
  echo -e "\n\t[+] Proceso finalizado.\n"
  tput cnorm
}

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

#Ctrl+C
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

trap ctrl_c INT

function helpPanel(){
  echo -e "${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}${purpleColour} $0${endColour}\n"
  echo -e "\t${blueColour}[+]${endColour} ${grayColour}-m <valor>: Indica la cantidad de dinero inicial.${endColour}"
  echo -e "\t${blueColour}[+]${endColour} ${grayColour}-t <técnica empleada>: Indica la técnica empleada ("martingala" o "inverse" son los valores aceptados)${endColour}"
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dinero actual: ${endColour}${blueColour}$money${endColour}\n"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}Cuando dinero quieres apostar? -> ${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}A qué deseas apostar continuamente?  [par,impar] -> ${endColour}" && read par_impar

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con una cantidad inicial de ${endColour}${blueColour}$initial_bet${endColour} ${grayColour}a ${endColour}${blueColour}$par_impar${endColour}"
  backup_bet=$initial_bet
  play_counter=1
  jugadas_malas="[ "
  top_money=$initial_bet
  tput civis #ocultar el cursor


  while true; do
    money=$(($money-$initial_bet))
#    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar: ${endColour}${blueColour}$initial_bet €${endColour}${grayColour} y tienes ${endColour}${blueColour}$money €${endColour}"
    random_number="$(($RANDOM % 37))"
#    echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el número: ${endColour}${blueColour}$random_number${endColour}"
    if [ ! "$money" -le 0 ]; then
      if [ "$par_impar" == "par" ]; then
        #Todo este bloque es si elegimos PAR
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$(($random_number))" -eq 0 ]; then
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}El número que ha salido es cero${endColour}"
            jugadas_malas+="$random_number "
            initial_bet=$(($initial_bet*2))
             if [ "$initial_bet" -gt "$money" ]; then
#             echo -e "${yellowColour}[+]${endColour} ${redColour}No tenemos suficiente para la próxima apuesta${endColour}"
              echo -e "${yellowColour}[+]${endColour} ${redColour}Hemos jugado un total de${endColour} ${blueColour}$play_counter${endColour} ${grayColour}jugadas${endColour}"
              $jugadas_malas.=" ]"
              echo -e "${yellowColour}[+]${endColour} ${redColour}Las jugadas malas que han salido son:${endColour} ${blueColour}$jugadas_malas${endColour}"
              echo -e "${yellowColour}[+]${endColour} ${redColour}La mayor cantidad de dinero que hemos tenido ha sido: ${endColour} ${blueColour}$top_money${endColour}"
              tput cnorm; exit 0
             fi
#              echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo tienes un total de${endColour} ${redColour}$money €${endColour}"
          else
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}El número que ha salido es par, por lo que hemos${endColour} ${greenColour}ganado${endColour}"
            reward=$(($initial_bet*2))
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ganas un total de${endColour} ${blueColour}$reward €${endColour}"
            money=$(($money+$reward))
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes un total de${endColour} ${blueColour}$money €${endColour}"
            initial_bet=$backup_bet
#            if [ "$money" -gt "$top_money" ]; then
#              $top_money=$money
#            fi
            jugadas_malas=""
          fi
        else
#          echo -e "${yellowColour}[+]${endColour} ${grayColour}El número que ha salido es impar, por lo que hemos${endColour} ${redColour}perdido${endColour}"
          initial_bet=$(($initial_bet*2))
#          echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo tienes un total de${endColour} ${redColour}$money €${endColour}"
          if [ "$initial_bet" -gt "$money" ]; then
            echo -e "${yellowColour}[+]${endColour} ${redColour}No tenemos suficiente para la próxima apuesta${endColour}"
            echo -e "${yellowColour}[+]${endColour} ${redColour}Hemos jugado un total de${endColour} ${blueColour}$play_counter${endColour} ${grayColour}jugadas${endColour}"
            $jugadas_malas.=" ]"
            echo -e "${yellowColour}[+]${endColour} ${redColour}Las jugadas malas que han salido son:${endColour} ${blueColour}$jugadas_malas${endColour}"
#            echo -e "${yellowColour}[+]${endColour} ${redColour}La mayor cantidad de dinero que hemos tenido ha sido: ${endColour} ${blueColour}$top_money${endColour}"
            tput cnorm; exit 0
          fi
          jugadas_malas+="$random_number "
        fi
#       sleep 0.05 
      else
        #Todo este bloque es si elegimos PAR
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$(($random_number))" -eq 0 ]; then
             jugadas_malas+="$random_number "
             initial_bet=$(($initial_bet*2))
             if [ "$initial_bet" -gt "$money" ]; then
#             echo -e "${yellowColour}[+]${endColour} ${redColour}No tenemos suficiente para la próxima apuesta${endColour}"
              echo -e "${yellowColour}[+]${endColour} ${redColour}Hemos jugado un total de${endColour} ${blueColour}$play_counter${endColour} ${grayColour}jugadas${endColour}"
              $jugadas_malas.=" ]"
              echo -e "${yellowColour}[+]${endColour} ${redColour}Las jugadas malas que han salido son:${endColour} ${blueColour}$jugadas_malas${endColour}"
#             echo -e "${yellowColour}[+]${endColour} ${redColour}La mayor cantidad de dinero que hemos tenido ha sido: ${endColour} ${blueColour}$top_money${endColour}"
              tput cnorm; exit 0
             fi
             echo -e "${yellowColour}[+]${endColour} ${grayColour}El número que ha salido es cero${endColour}"
          else
            echo -e "${yellowColour}[+]${endColour} ${grayColour}El número que ha salido es par, por lo que hemos${endColour} ${redColour}perdido${endColour}"
            initial_bet=$(($initial_bet*2))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo tienes un total de${endColour} ${redColour}$money €${endColour}"
            if [ "$initial_bet" -gt "$money" ]; then
              echo -e "${yellowColour}[+]${endColour} ${redColour}No tenemos suficiente para la próxima apuesta${endColour}"
              echo -e "${yellowColour}[+]${endColour} ${redColour}Hemos jugado un total de${endColour} ${blueColour}$play_counter${endColour} ${grayColour}jugadas${endColour}"
              $jugadas_malas.=" ]"
              echo -e "${yellowColour}[+]${endColour} ${redColour}Las jugadas malas que han salido son:${endColour} ${blueColour}$jugadas_malas${endColour}"
#             echo -e "${yellowColour}[+]${endColour} ${redColour}La mayor cantidad de dinero que hemos tenido ha sido: ${endColour} ${blueColour}$top_money${endColour}"
              tput cnorm; exit 0
            fi
            jugadas_malas+="$random_number "
          fi
        else
          echo -e "${yellowColour}[+]${endColour} ${grayColour}El número que ha salido es impar, por lo que hemos ganado${endColour}"
          reward=$(($initial_bet*2))
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Ganas un total de${endColour} ${blueColour}$reward €${endColour}"
          money=$(($money+$reward))
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes un total de${endColour} ${blueColour}$money €${endColour}"
          initial_bet=$backup_bet
#         if [ "$money" -gt "$top_money" ]; then
#           $top_money=$money
#         fi
          jugadas_malas=""
        fi
      fi
    else
      # Nos quedamos sin dinero
          echo -e "${yellowColour}[+]${endColour} ${redColour}Nos hemos quedado sin dinero${endColour}"
          echo -e "${yellowColour}[+]${endColour} ${redColour}Hemos jugado un total de${endColour} ${blueColour}$play_counter${endColour} ${grayColour}jugadas${endColour}"
          tput cnorm; exit 0
    fi
    let play_counter+=1
   done
  tput cnorm #Recuperar el cursor
}

function inversa(){
  echo -e "${yellowColour}[+]${endColour}${grayColour}La técnica elegida es ${endColour}${blueColour}LaBrouchere inversa${endColour}\n"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dinero actual: ${endColour}${blueColour}$money${endColour}\n"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}A qué deseas apostar continuamente?  [par,impar] -> ${endColour}" && read par_impar
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con la técnica LaBrouchere inversa a ${endColour}${blueColour}$par_impar${endColour}"

  declare -a my_sequence=(1 2 3 4)

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comenzamos con la secuencia ${endColour}${blueColour}${my_sequence[@]}${endColour}"

  bet="$((${my_sequence[0]} + ${my_sequence[-1]}))"

  my_sequence=(${my_sequence[@]})
  jugadas_totales=0
  bet_to_renew=$(($money+50)) # Dinero que renueva la secuencia para jugar con beneficios
  tput civis
  while [[ true ]]; do
    let jugadas_totales+=1
    random_number="$(($RANDOM % 37))"
    money=$(($money-$bet))
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Tenemos ${endColour}${blueColour}${money} €${endColour}"
    echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el número: ${endColour}${blueColour}$random_number${endColour}"
    if [[ $bet -gt $money ]]; then
      echo -e "\n${redColour}[!]${endColour} ${grayColour}No tenemos suficiente dinero para continuar apostando ${endColour}"
      echo -e "\n${redColour}[!]${endColour} ${grayColour}El número total de jugadas han sido:${endColour}${blueColour} $jugadas_totales ${endColour}"
      tput cnorm; exit 0
    fi
    if [[ $money -le 0 ]]; then
      echo -e "\n${redColour}[!]${endColour} ${grayColour}No tenemos suficiente dinero para continuar apostando ${endColour}"
      echo -e "\n${redColour}[!]${endColour} ${grayColour}El número total de jugadas han sido:${endColour}${blueColour} $jugadas_totales ${endColour}"
      tput cnorm; exit 0
    fi
    if [[ $money -gt $bet_to_renew ]]; then
      bet_to_renew+=50
      my_sequence=(1 2 3 4)
    fi
    if [[ "$par_impar" == "par" ]]; then
      # Apostamos a par
      if [[ "$(($random_number % 2))" -eq 0 ]]; then
        if [[ "$random_number" -eq 0 ]]; then
          echo -e "${redColour}[!]${endColour} ${grayColour}El número es ${endColour}${redColour}$random_number${endColour} ${grayColour}, has perdido${endColour}"
          unset my_sequence[0]
          unset my_sequence[-1] 2>/dev/null
          my_sequence=(${my_sequence[@]})
          echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
          if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
            bet="$((${my_sequence[0]}+${my_sequence[-1]}))"
          elif [[ "${#my_sequence[@]}" -eq 1 ]]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColour}[!]${endColour} ${grayColour}Nos hemos quedado ${endColour}${redColour}sin esta secuencia${endColour}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Reestablecemos la secuencia a: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
          fi
        else
          echo -e "${yellowColour}[+]${endColour} ${grayColour}El número es ${endColour}${blueColour}par${endColour} ${grayColour}, has ganado${endColour}"
          reward=$(($bet*2))
          let money+=$reward
          my_sequence+=($bet)
          my_sequence=(${my_sequence[@]})
          echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
          if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
            bet="$((${my_sequence[0]} + ${my_sequence[-1]}))"
          elif [[ "${#my_sequence[@]}" -eq 1 ]]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColour}[!]${endColour} ${grayColour}Nos hemos quedado ${endColour}${redColour}sin esta secuencia${endColour}"
            echo -e "${redColour}[!]${endColour} ${grayColour}Nos hemos quedado ${endColour}${redColour}sin esta secuencia${endColour}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Reestablecemos la secuencia a: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
          fi
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes ${endColour}${blueColour}$money €${endColour}"
        fi
      else
        echo -e "${redColour}[!]${endColour} ${grayColour}El número es ${endColour}${redColour}impar${endColour} ${grayColour}, has perdido${endColour}"
        unset my_sequence[0]
        unset my_sequence[-1] 2>/dev/null
        my_sequence=(${my_sequence[@]})
        echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
        if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
          bet="$((${my_sequence[0]}+${my_sequence[-1]}))"
        elif [[ "${#my_sequence[@]}" -eq 1 ]]; then
          bet=${my_sequence[0]}
        else
          echo -e "${redColour}[!]${endColour} ${grayColour}Nos hemos quedado ${endColour}${redColour}sin esta secuencia${endColour}"
          my_sequence=(1 2 3 4)
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Reestablecemos la secuencia a: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
        fi
      fi
    fi
    sleep 0
  done

  tput cnorm
}


while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  echo -e "${yellowColour}[+]${endColour}${grayColour} Voy a jugar con${endColour} ${blueColour}$money €${endColour} ${grayColour}usando la técnica${endColour} ${blueColour}$technique${endColour}"
    if [ $technique == "martingala" ]; then
      martingala
    elif [ $technique == "inverse" ]; then
      inversa
    else
      echo -e "${redColour}[+]${endColour} ${grayColour}La técnica introducida no existe${endColour}\n"
      helpPanel
    fi
else
  helpPanel
fi

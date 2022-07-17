#!/bin/bash
username="$1"  # Stores the 1st arguement which is the name
idNumber="$2"  # Stores the 2nd arguement which is the ID
re='^[0-9]+$'  # Helps to check if there is any numbers in name
PASSCT=1       # Password counter to count how many times password is wrong
tries=2        # Keeps track of the amount of tries left for the user entering the password
STOP="\e[0m"   # Helps to remove any text decorations
CYAN="\e[96m"  # color assignment
BLUE="\e[34m"  # color assignment
BLINK="\e[5m"  # makes the text blink

function print_centered # Function for centering texts and also make row decorations Expencted Use: (print_centered Text)
{
    [[ $# == 0 ]] && return 1
    declare -i TERM_COLS="$(tput cols)"  #get window size
    declare -i str_len="${#1}"

    [[ $str_len -ge $TERM_COLS ]] && {
        echo "$1";
        return 0;
    }

    declare -i filler_len="$(( (TERM_COLS - str_len) / 2 ))" #deviding the window to half by calculating
    [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
    filler=""
    for (( i = 0; i < filler_len; i++ )); do
        filler="${filler}${ch}"
    done
    printf "%s%s%s" "$filler" "$1" "$filler"  #adding filler/space to ceneter the content respectively
    [[ $(( (TERM_COLS - str_len) % 2 )) -ne 0 ]] && printf "%s" "${ch}"
    printf "\n"
    return 0
}


function header()    # Function for decorating the header Expected Use: (header borderColor textColor title figletDecoration)
{
    printf "$1"
    print_centered " " " "
    printf "${STOP}"
    printf "$2"
    figlet -f "$4" -t -c "$3"
    printf "${STOP}"
    printf "$1"
    print_centered " " " "
    printf "${STOP}"
}

function border()    # Function for border decoration Expected Use:(border color)
{
    printf "$1"
    print_centered " " " "
    printf "${STOP}"
}

function check_arguement(){  # Function to check the arguements are typed in properly
    if [ $# -lt 2 ]               # Check if there is less than 2 arguements
    then
        echo -e "\e[91m(Arguement insufficient)\e[93m\e[1m Usage\e[0m:\e[93m Please Enter the command line argument as follows:\e[93m\e[5m (./20049037cw2pii FirstName IdNumber)\e[0m"
    elif [ $# -gt 2 ]             # Check if there is more than 2 arguements
    then
        echo -e "\e[91m(Arguement limit exceeded)\e[93m\e[1m Usage\e[0m:\e[93m Please Enter the command line argument as follows:\e[93m\e[5m (./20049037cw2pii FirstName IdNumber)\e[0m"
    elif [[ $username =~ $re ]]  # Checks if there is any numbers in the users Name
    then
        echo -e "\e[91m(First Name error)\e[93m\e[1m Usage\e[0m:\e[93m Please Enter the command line argument as follows:\e[93m\e[5m (./20049037cw2pii FirstName IdNumber)\e[0m"
    elif ! [[ $idNumber =~ $re ]] #  Checks if id conytains only numbers or not
    then
        echo -e "\e[91m(ID error)\e[93m\e[1m Usage\e[0m:\e[93m Please Enter the command line argument as follows:\e[93m\e[5m (./20049037cw2pii FirstName IDNumber)\e[0m"
    else
        echo;echo;
        print_centered "-" "-"
        echo;
        echo -e "\e[36mPlease enter the password to continue in the program\e[0m"
        echo
        password # Executes password function
    fi
}


function password()    # Function for input and checking of the password from the user
{
    SECRET_KEY="SDhakz"                 # Secret KEY
    echo -e -n "Password: "
    read -s MYPWD
    if [ "$MYPWD" = "$SECRET_KEY" ]     # Checks if user inputted password matches the Secret key
    then
        echo -e "\e[40;38;5;82mPassword accepted\e[0m"
        echo
        print_centered "-" "-"
        PASSCT=1
        start                           # Starting of the game
    else
        while [ $PASSCT -lt 4 ]         # Loop for number of tries for password
        do
            echo -e "\e[41mWrong password you have \e[7m $tries \e[0m\e[41m tries left\e[0m "
            (( PASSCT++ ))
            (( tries-- ))
            break
        done

        if [ $PASSCT == 4 ]             # Terminates program if the user exceeds the amount of password tries
        then
            echo;echo -e "\e[91m\e[5mYou have entered the password wrong 3 times, the program will be terminated\e[0m";echo
        else
            password                    # Re-executes password function
        fi
    fi
}


function start ()       # Function to print the user details along with execution time and date
{
    now=$(date +%Y-%b-%a)       # Current Date assignment
    time=$(date +%T)            # Current time assignment
    echo;border "\e[34m\e[7m";echo
    printf "${BLINK}"
    printf "${CYAN}"
    figlet -t -c "Welcome to the Band game"
    printf "${STOP}"
    echo -e "\n";border "\e[34m\e[7m";echo

    function details()  # Function to print the details of the user
    {
        echo
        figlet -c -t -f digital "Your details"
        echo
        print_centered "Username: $username    "
        print_centered "User ID: $idNumber    "
        print_centered "Execution Date: $now    "
        print_centered "Execution Time: $time    "
    }
    print_centered "-" "-" | lolcat
    details | boxes -d parchment -a c | lolcat -a -d 1
    echo
    print_centered "-" "-" | lolcat
    sleep 0.5
    menu # Executes menu function
}

function menu() # Function for menu contents
{
    function menu_list() # Function for listing the menu items
    {
        echo
        print_centered "1) Start Game                    ";echo
        print_centered "2) About Game                    ";echo
        print_centered "3) Exit  Game                    ";echo
    }

    function menu_input()  # Function for taking users menu input and validation
    {
        echo
        printf "\e[38;5;227m"
        print_centered "-" "-"
        printf "${STOP}"
        echo
        echo -e -n "\e[93mPlease enter a number(1-3): \e[0m";read menuItem
        case $menuItem in
            1)
                echo -e "\n\e[92mGame started successfully\e[0m\n"
                border "\e[33m\e[7m"
                guess_band  # Executes guess_band function which is the guessing band phase
            ;;
            2)
                echo;header "\e[91m\e[7m" "\e[38;5;204m" "About Info" "small";echo
                printf "\e[91m";cat ./about.txt;printf "${STOP}"   # Opents the about info text file
                echo
                border "\e[91m\e[7m"
                check menu exit "Do you want to go back to the menu (yes/no): "
            ;;
            3)
                quit
            ;;
            *)
                echo -e "\e[91mPlease type valid number between 1 and 3\e[0m"
                menu_input
        esac
    }
    echo;header "\e[33m\e[7m" "\e[93m" "MENU" "small"
    printf "\e[38;5;226m"
    echo;menu_list |boxes -d scroll
    printf "${STOP}"
    menu_input # Calling menu_input function
}

function quit()  # Function for terminating the program
{
    echo;header "\e[34m\e[7m" "\e[96m" "Thank You for playing the game" "standard";echo
    exit
}

function guess_band()  # Function for guessing the band
{
    echo
    header "\e[36m\e[7m" "\e[96m" "Guess the best Band" "small"

    function band_codes() # Function for displaying the Band names along with the codes
    {
        echo;
        print_centered "AC/DC    -------------------------------  AD                     ";echo
        print_centered "Beatles  -------------------------------  BE                     ";echo
        print_centered "Blondie  ------------------------------  BLO                     ";echo
        print_centered "Nirvana  ------------------------------  NIR                     ";echo
        print_centered "Queen    ------------------------------  QUE                     ";echo
    }
    echo;printf "${CYAN}" ;band_codes | boxes -d scroll-akn;printf "${STOP}";echo       # Calling band_codes function with decorations
    printf "\e[36m";print_centered "-" "-";printf "${STOP}"

    function guess()    # Function for input and validation of the codes entered by the user
    {
        echo
        echo -e -n "\e[93mEnter the band code: \e[0m";read bandCode
        echo
        case $bandCode in
            "BE")
                echo
                printf "\e[91m\e[5m";figlet -f small -t -c "Wrong Answer" | boxes -d nuke ;printf "${STOP}"
                header "\e[31m\e[7m" "\e[91m" "Sorry Beatles is not the correct band" "small"
                check guess_band menu "Do you want to retry (yes/no): " "\e[31m\e[7m"                   # Executing the check function which executes guess_band function if yes or executes menu function if no is pressed
            ;;
            "AD")
                echo
                printf "\e[91m\e[5m";figlet -f small -t -c "Wrong Answer" | boxes -d nuke ;printf "${STOP}"
                header "\e[31m\e[7m" "\e[91m" "Sorry AC/DC is not the correct band" "small"
                check guess_band menu "Do you want to retry (yes/no): " "\e[31m\e[7m"                   # Executing the check function which executes guess_band function if yes or executes menu function if no is pressed
            ;;
            "QUE")
                border "\e[36m\e[7m"
                echo
                header "\e[32m\e[7m" "\e[92m" "Congratulations you have selected the correct band" "small"
                sleep 0.4
                echo
                printf "\e[95m\e[5m";figlet -f slant  -t -c QUEEN;printf "${STOP}"
                echo
                cat ./QUE/Queen.txt;
                check choose_members menu "Do you want to go to the next stage? (yes/no): " "\e[32m\e[7m" # Executing the check function which executes choose_members function if yes or executes menu function if no is pressed
            ;;
            "BLO")
                echo
                printf "\e[91m\e[5m";figlet -f small -t -c "Wrong Answer" | boxes -d nuke ;printf "${STOP}"
                header "\e[31m\e[7m" "\e[91m" "Sorry Blondie is not the correct band" "small"
                check guess_band menu "Do you want to retry (yes/no): " "\e[31m\e[7m"                      # Executing the check function which executes guess_band function if yes or executes menu function if no is pressed
            ;;
            "NIR")
                echo
                printf "\e[91m\e[5m";figlet -f small -t -c "Wrong Answer" | boxes -d nuke ;printf "${STOP}"
                header "\e[31m\e[7m" "\e[91m" "Sorry Nirvana is not the correct band" "small"
                check guess_band menu "Do you want to retry (yes/no): " "\e[31m\e[7m"                      # Executing the check function which executes guess_band function if yes or executes menu function if no is pressed
            ;;
            *)
                echo -e  "\e[93m\e[1mUsage\e[0m:\e[91m Please enter one of the codes as shown\e[93m\e[5m (AD/BE/BLO/QUE/NIR)\e[0m"
                guess # Re-executes guess function
        esac
    }
    guess # Calling guess function
}


function check() # Function to check if user wants to go to certaing stage when there is YES or NO option presented Expected Use: ( check function(case:yes) function(case:no) message borderColor)
{
    echo -e "\n"
    printf "\e[32m"
    print_centered "-" "-"
    print_centered "-" "-"
    printf "${STOP}"
    printf "\e[92m"
    echo -e -n "$3"
    printf "${STOP}"
    read stage2
    upper=${stage2^^}
    echo
    if [[ $upper == "YES" ]]
    then
        border "$4"
        $1
    elif [[ $upper == "NO" ]]
    then
        $2
    else
        echo -e "Usage:\e[91m Please enter yes or no\e[0m"
        check "$@"  # Re-executes check function passing the same arguements
    fi
}


function choose_members()  # Function for display input and validation of the codes of the members inputted by the user
{
    echo
    header "\e[36m\e[7m" "\e[96m" "Choose Any 3 members" "small"

    function member_codes() # Function for displaying the members and their codes
    {
        echo
        print_centered "John Lennon      ------------------------  JL                   ";echo
        print_centered "Agnus Young      ------------------------  AY                   ";echo
        print_centered "Freddie Mercury  ------------------------  FM                   ";echo
        print_centered "Debbie Harry     ------------------------  DH                   ";echo
        print_centered "Kurt Cobain      ------------------------  KC                   ";echo
    }
    echo;printf "${CYAN}" ;member_codes | boxes -d scroll-akn;printf "${STOP}";echo # Executes member_codes fuhnction with decorations

    function choice() #function to check if user inputs 3 codes correctly
       {
        printf "\e[36m"
        print_centered "-" "-"
        printf "${STOP}"
        echo -e -n "\e[93mEnter the options from above: \e[0m "
        read M1 M2 M3
                function checking() # Function for checking if the user inputs correct amount of arguements and correct codes
                {
                in1=$1  # 1st code
                in2=$2  # 2nd code
                in3=$3  # 3rd code
                c=$#    # Number of arguements passed in the checking function
                myArray=("JL" "AY" "FM" "DH" "KC")
                if [[ $c -eq  3 ]] # Checks if there are 3 arguements
                then
                        if [[ " ${myArray[*]} " =~ " ${in1} " && " ${myArray[*]} " =~ " ${in2} " && " ${myArray[*]} " =~ " ${in3} " ]]  # Checks if the inputted codes matches the ones in the array
                        then
                            if [[ $in1 != $in2 && $in1 != $in3 && $in2 != $in3 ]] # Checks if the inputted codes are duplicate
                                    then
                                        echo -e "\e[92mSuccess\e[0m"
                                        echo
                                        border "\e[36m\e[7m"
                                        guess_members $in1 $in2 $in3 # Executes guess_members function passing the inputted arguements
                            else
                                        echo -e "\e[93m\e[1mUsage\e[0m:\e[91m You have entered a members code more than once please try again. Example:\e[93m\e[5m JL AY FM\e[0m"
                                        re_enter choice "Please try again in" #Calling re_enter function passing parameter choice
                            fi
                        else
                                echo;echo -e "\e[93m\e[1mUsage\e[0m:\e[91m Please enter the codes that are shown correctly. Example\e[93m\e[5m JL AY FM\e[0m"
                                re_enter choice "Please try again in" #Calling re_enter function passing parameter choice
                        fi
                elif [[ $c -gt 3 ]]  # Checks if there are more than 3 arguements
                then
                        echo -e "\e[93m\e[1mUsage\e[0m:\e[91m (More than 3 arguments detected) Please type only 3 arguments as the example given: Example\e[93m\e[5m JL AY FM\e[0m"
                        re_enter choice "Please try again in" #Calling re_enter function passing parameter choice
                elif [[ $c -lt 3 ]]  # Checks if there are less than 3 arguements
                then
                        echo -e "\e[93m\e[1mUsage\e[0m:\e[91m (Less than 3 arguements detected) Please type only 3 arguements as the example given: Example\e[93m\e[5m JL AY FM\e[0m"
                        re_enter choice "Please try again in" #Calling re_enter function
                fi
                }
        checking $M1 $M2 $M3
        }
    choice #Calling the choice function
}




function re_enter() # Function to countdown for retrial Expectesd Use: (re_enter function message)
{
    echo
    a=3
    until [ $a -eq 0 ]
    do
        echo -e "\e[94m$2\e[93m $a seconds"
        (( a-- ))
        sleep 0.8
    done
    $1
}

function guess_members() # Function for input display and vlidation of the membes of the band
{
    echo
    header "\e[36m\e[7m" "\e[96m" "Choose One of the member out of three" "small"
    echo -e "\n"
    arrName=()          # Creation of array for storing the display text
    function pushArray()     # Function for checking if the codes match the cases to push the value in the array
    {
        case $1 in
            "JL")
                arrName+="John_Lennon(JL) "
            ;;
            "AY")
                arrName+="Agnus_Young(AY) "
            ;;
            "FM")
                arrName+="Freddie_Mercury(FM) "
            ;;
            "DH")
                arrName+="Debbie_Harry(DH) "
            ;;
            "KC")
                arrName+="Kurt_Cobain(KC) "
            ;;
        esac
    }
    pushArray $1 # Executing the pushArray function with 1st arguement
    pushArray $2 # Executing the pushArray function with 2nd arguement
    pushArray $3 # Executing the pushArray function with 3rd arguement
    PS3="Enter one of the number from above: "
    select var in $arrName   # select valuess in the array
    do
        case $var in
            "John_Lennon(JL)")
                FILENAME="./JL/JL.txt"
                if [[ ! -f $FILENAME ]] || [[ ! -r $FILENAME ]]
                then
                    echo
                    echo -e "\e[91mNo files found for John Lennon\e[0m"
                    re_enter menu "You will be redirected to the menu screen in" # Executes re_enter function redirecting to menu
                else
                    cat $FILENAME
                fi
            ;;
            "Freddie_Mercury(FM)")
                FILENAME="./FM/FM.txt"
                if [[ ! -f $FILENAME ]] || [[ ! -r $FILENAME ]]
                then
                    echo
                    echo -e "\e[91mNo files found for Freddie Mercury\e[0m"
                    re_enter menu "You will be redirected to the menu screen in" # Executes re_enter function redirecting to menu
                else
                    echo
                    border "\e[36m\e[7m"
                    echo
                    header "\e[31m\e[7m" "\e[91m" "Freddie Mercury" "smscript";echo
                    echo -e "\e[93m(FM) \e[41m\e[5mFreddie Mercury\e[0m lead performer of the band Queen"
                    echo
                    jp2a  --background=dark --size=50x30 --colors --red=0 --blue=0.5 --green=0.5 ./FM/FM.jpg;echo
                    cat $FILENAME
                    echo -e "\n\n"
                    border "\e[31m\e[7m"
                    check menu quit "Do you want to restart the game? (yes/no): " # Executes check function
                fi
            ;;
            "Debbie_Harry(DH)")
                FILENAME="./DH/DH.txt"
                if [[ ! -f $FILENAME ]] || [[ ! -r $FILENAME ]]
                then
                    echo
                    echo -e "\e[91mNo files found for Debbie Harry\e[0m"
                    re_enter menu "You will be redirected to the menu screen in"
                else
                    echo
                    border "\e[36m\e[7m"
                    echo
                    header "\e[33m\e[7m" "\e[93m" "Debbie Harry" "small";echo
                    echo -e "\e[93m(DH) \e[31m\e[43m\e[5mDebbie Harry\e[0m lead performer of the band Blondie"
                    echo
                    jp2a --size=50x30 --colors ./DH/DH.jpg;echo
                    cat $FILENAME
                    echo -e "\n\n"
                    border "\e[33m\e[7m"
                    check menu quit "Do you want to restart the game? (yes/no): " # Executes check function
                fi
            ;;
            "Kurt_Cobain(KC)")
                FILENAME="./KC/KC.txt"
                if [[ ! -f $FILENAME ]] || [[ ! -r $FILENAME ]]
                then
                    echo
                    echo -e "\e[91mNo files found for Kurt Cobain\e[0m"
                    re_enter menu "You will be redirected to the menu screen in" # Executes re_enter function redirecting to menu
                else
                    cat $FILENAME
                fi
            ;;
            "Agnus_Young(AY)")
                FILENAME="./AY/AY.txt"
                if [[ ! -f $FILENAME ]] || [[ ! -r $FILENAME ]]
                then
                    echo
                    echo -e "\e[91mNo files found for Agnus Young\e[0m"
                    re_enter menu "You will be redirected to the menu screen in"
                else
                    echo
                    border "\e[36m\e[7m"
                    echo
                    header "\e[36m\e[7m" "\e[92m" "Agnus Young" "smslant";echo
                    echo -e "\e[92m(DH) \e[91m\e[42m\e[5mAgnus Young\e[0m Lead Guitarist of the band AC/DC"
                    echo
                    jp2a --size=50x30 --colors  ./AY/AY.jpg;echo
                    cat $FILENAME
                    echo -e "\n\n"
                    border "\e[36m\e[7m"
                    check menu quit "Do you want to restart the game? (yes/no): " # Executes check function
                fi
            ;;
            *)
                echo -e "\e[91m\e[1mUsage\e[0m:\e[91m Please enter number correctly \e[93m\e[5m(1-3)\e[0m"
            ;;
        esac
    done
}

check_arguement "$@" #Calling the check_arguement function

#!/bin/sh

number_of_days=""

Help()
{
   # Display Help
   echo ""
   echo "Description of the Killing Sleep Sessions"
   echo 
   echo "Syntax: ${NAME} [-h|d]"
   echo "options:"
   echo "h     Show help"
   echo "d     Mention Minimum Number Of Days"
   echo ""
   echo "[For Example: ./script.sh -d 1 ][It will terminate sessions that are 1 or more days old]"
   echo ""
}

Kill_session()
{
	#CURRENT STATS OF CPU LOAD, MEMORY USAGE
	
	total_mem=$(echo $(free -g | grep Mem | awk '{print $2}'))
	used_mem=$(echo $(free -g | grep Mem | awk '{print $3}'))
	free_mem=$(echo $(free -g | grep Mem | awk '{print $4}'))
	avail_mem=$(echo $(free -g | grep Mem | awk '{print $7}'))
	
	total_swap=$(echo $(free -g | grep Swap | awk '{print $2}'))
	used_swap=$(echo $(free -g | grep Swap | awk '{print $3}'))
	free_swap=$(echo $(free -g | grep Swap | awk '{print $4}'))
	
	load_avg=$(echo $(uptime | cut -d ',' -f 4-6 | sed -e 's/^[ \t]*//'))
	
	echo "---------------------------------------------"
	echo ""
	echo ""
	echo "STATS BEFORRE THE SLEEPING SESSION TERMINATION"
	echo ""
	echo CPU $load_avg 
	echo ""
	echo Total Memory: $total_mem GB
	echo Used Memory: $used_mem GB
	echo Free Memory: $free_mem GB
	echo Available Memory: $avail_mem GB
	echo "" 
	echo Total Swap: $total_swap GB
	echo Used Swap: $used_swap GB
	echo Free Swap: $free_swap GB
	echo ""
	echo ""
	echo "---------------------------------------------"
	echo ""
	echo "USER SESSIONS"
	#END OF STATS
	
	#------------------------------------
	#START
	#TERMINATE SESSIONS OF LAST TWO DAYS
	#------------------------------------
	
	#********************
	#Number of days
	#number_of_days=1
	#its mean killing sleep sessions
	#of one or more days
	#********************
	
	sudo x2golistsessions_root | awk '{split ($0,a,"|"); print a[2], a[5], a[6], a[11]}' | grep " S " > sleep_session.output
	while read line; do
	temp=$(echo $(echo $line | awk '{split ($0,a," "); print a[1], a[4]}'))
	
	get_id=$(echo $(echo $temp | awk '{split ($0,a," "); print a[1]}'))
	get_date=$(echo $(echo $temp | awk '{split ($0,a," "); print a[2]}' |  awk '{split ($0,a,"T"); print a[1]}'))
	
	#echo $get_id
	#echo $get_date
	
	normalize_date=$(echo $(echo "${get_date//-}"))
	#echo $normalize_date
	
	current_date=$(echo $(date "+%Y-%m-%d"))
	current_date=$(echo $(echo "${current_date//-}"))
	#echo $current_date
	
	diff_day=$(echo $(( ( $(date --date=$current_date +%s) - $(date --date=$normalize_date +%s))/(60*60*24) )))
	#echo $diff_day
	
	if [ "$diff_day" -ge "$number_of_days" ];then
	#echo $diff_day
	#echo $get_id
	#echo $current_date
	#echo $normalize_date
	echo Killing Session: $get_id Sessions: $diff_day day old
	sudo /bin/x2goterminate-session $get_id
	fi
	done < sleep_session.output
	
	#------------------------------------
	#END
	#TERMINATE SESSIONS OF LAST TWO DAYS
	#------------------------------------
	
	
	#Sleep to get STATS after delay
	sleep 10
	
	
	#--------------------------------------------
	#AFTER SCRIPT STATS OF CPU LOAD, MEMORY USAGE
	
	total_mem=$(echo $(free -g | grep Mem | awk '{print $2}'))
	used_mem=$(echo $(free -g | grep Mem | awk '{print $3}'))
	free_mem=$(echo $(free -g | grep Mem | awk '{print $4}'))
	avail_mem=$(echo $(free -g | grep Mem | awk '{print $7}'))
	
	total_swap=$(echo $(free -g | grep Swap | awk '{print $2}'))
	used_swap=$(echo $(free -g | grep Swap | awk '{print $3}'))
	free_swap=$(echo $(free -g | grep Swap | awk '{print $4}'))
	
	load_avg=$(echo $(uptime | cut -d ',' -f 4-6 | sed -e 's/^[ \t]*//'))
	
	echo "---------------------------------------------"
	echo ""
	echo ""
	echo "STATS AFTER THE SLEEPING SESSION TERMINATION"
	echo ""
	echo CPU $load_avg 
	echo ""
	echo Total Memory: $total_mem GB
	echo Used Memory: $used_mem GB
	echo Free Memory: $free_mem GB
	echo Available Memory: $avail_mem GB
	echo "" 
	echo Total Swap: $total_swap GB
	echo Used Swap: $used_swap GB
	echo Free Swap: $free_swap GB
	echo ""
	echo ""
	echo "---------------------------------------------"
	
	#END OF STATS
	#---------------------------------------------
}


while getopts ":d:h" option; do
   case "${option}" in
      d) # No. of days
             number_of_days="${OPTARG}"
				#echo "${number_of_days}"
				Kill_session
                 ;;
      h) # display Help
         Help
         exit;;
     \?) # incorrect option
         echo "Invalid Option: -$OPTARG" 1>&2
		exit 1;;
   esac
done
shift $(( OPTIND - 1 ))

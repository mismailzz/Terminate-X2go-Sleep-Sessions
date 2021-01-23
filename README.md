# Terminate-X2go-Sleep-Sessions
This script will terminate the x2go sleeping sessions that are old for given number of days. The sleeping sessions will be terminated that are old from the given and more days. Its mean that the given days value is the minimum threshold that you are going to given. But you can customize the script in a way that it will terminate only those sessions that are old for given days. For this customization you can change the "if [ "$diff_day" -ge "$number_of_days" ]" condition to "if [ "$diff_day" -eq "$number_of_days" ]". The CPU, Memory and Swap status will be shared before and after the execution of the script. For System stats the 10second "sleep 10" delay is used but you can modify it for your requirement.   


# Description of the Killing Sleep Sessions

options:

h     Show help

d     Mention Minimum Number Of Days


[For Example: ./script.sh -d 1 ][It will terminate sessions that are 1 or more days old]

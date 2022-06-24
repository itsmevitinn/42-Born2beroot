#!/bin/bash

ARCH_KERNEL=$(uname -a)
MAX_MEM=$(free -m | awk 'FNR == 2 {print $2}')
MEM_USED=$(free -m | awk 'FNR == 2 {print $3}')
vCPU=$(cat /proc/cpuinfo | grep processor | wc -l)
CPU=$(lscpu | awk 'FNR == 5 {print $2}')
AVAILABLE_MEM=$(free -m | awk 'FNR == 2 {printf("%.2f"), ($3/$2)*100}')
TOTAL_DISK=$(df -Bm | grep -v "Filesystem" | awk '{totaldisk+=$2} END {printf "%i", totaldisk/1024}')
USED_DISK=$(df -Bm | grep -v "Filesystem" | awk '{useddisk+=$3} END {printf "%i", useddisk}')
PERCENTAGE_DISK=$(df -Bm | grep -v "Filesystem" | awk '{totaldisk+=$2} {useddisk+=$3} END {printf("%.0f"), (useddisk/totaldisk)*100}')
CPU_USAGE=$(top -bn 1| awk 'FNR == 3 {print $2}')
LAST_REBOOT=$(who -b | awk '{print $3, $4}')
CHECK_LVM=$(if grep -q "/dev/mapper" /etc/fstab 
then 
	echo "yes"
else
	echo "no" 
fi)
ACTIVE_CONNECTIONS=$(netstat -an | grep "ESTABLISHED$" | wc -l)
USER_LOG=$(who | awk '{print $1}' | sort -u | wc -l)
IP=$(hostname -I)
MAC=$(ip a | grep "link/ether" | awk '{print $2}')
SUDO_LOG=$(journalctl -q _COMM="sudo" | grep "COMMAND" | wc -l)

wall "#Architecture: ${ARCH_KERNEL} 
#CPU physical: ${CPU}
#vCPU : ${vCPU}
#Memory Usage: ${MEM_USED}/${MAX_MEM}MB (${AVAILABLE_MEM}%)
#Disk Usage: ${USED_DISK}/${TOTAL_DISK}Gb (${PERCENTAGE_DISK}%)
#CPU load: ${CPU_USAGE}%
#Last boot: ${LAST_REBOOT}
#LVM use: ${CHECK_LVM}
#Connections TCP : ${ACTIVE_CONNECTIONS} ESTABLISHED
#User log: ${USER_LOG}
#Network: IP ${IP}(${MAC})
#Sudo : ${SUDO_LOG} cmd"

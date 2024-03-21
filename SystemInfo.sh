#!/bin/bash


#error handling w/ command statements
if [ $# -eq 0 ]#if no command at all
    then
        echo "Usage: sysInfo <sys|mem|disk>"
fi

if [ "$1" != "sys" ] && [ "$1" != "mem" ] && [ "$1" != "disk" ]#if command is bad parameter
    then 
        if [ $# -ne 0  ]
            then
                echo "Error, invalid parameter."
        fi
fi

#sys menu
if [ "$1" == "sys" ]
    then   
        #assigning commands to respective variables which I can echo as formatted below
        UPTIME=$(uptime | awk '{print $3,$4}' | sed 's/,//')
        VERSION=$(uname -r) 
        OS=$(uname -o)
        KERNEL=$(uname -s)
        ARCHI=$(arch)
        USER=$(whoami)
        IP=$(hostname -I)
        PROCESSOR=$(awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//')
        MACHINE=$(vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi)
        echo "-----------------------System Information-----------------------"
        echo -e "Hostname:               $HOSTNAME"
        echo "uptime:                 $UPTIME"
        echo -e "Manufacturer:\t\t"`cat /sys/class/dmi/id/chassis_vendor`
        echo -e "Product Name:\t\t"`cat /sys/class/dmi/id/product_name`
        echo "Version:                $VERSION"
        echo "Machine Type:           $MACHINE"
        echo "Operating System:       $OS" 
        echo "Kernel:                 $KERNEL"
        echo "Architecture:           $ARCHI"
        echo "Processor:              $PROCESSOR"
        echo "Active User:            $USER"
        echo "Main System IP:         $IP" 
fi

#mem menu
if [ "$1" == "mem" ]
    then
        echo "---------------------CPU/Memory Usage-----------------------"
        free -h
        #assigning commands to respective variables which I can echo as formatted below
        SWAPUSAGE=$(cat /proc/stat | awk '/cpu/{printf("%.2f%%\n"), ($3/$2)*100}' | awk 'FNR == 2 {print $0}' | head -1)
        MEMUSAGE=$(cat /proc/stat | awk '/cpu/{printf("%.2f%%\n"), ($3/$2)*100}' | awk '{print $0}' | head -1)
        CPUUSAGE=$(cat /proc/stat | awk '/cpu/{printf("%.2f%%\n"), ($2+$4)*100/($2+$4+$5)}' | awk '{print $0}' | head -1)
        echo "Memory Usage:   $MEMUSAGE"
        echo "Swap Usage:     $SWAPUSAGE"
        echo "CPU Usage:      $CPUUSAGE"      
fi

#disk menu
if [ "$1" == disk ]
    then
        df -h | awk '$NF=="/"{printf "Disk Usage: %s\t\t\n\n", $5}'
        df -Ph | sed s/%//g | awk '{ if($5 > 80) print $0;}'
fi


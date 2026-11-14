#!/usr/bin/env bash

DISK() {
        local space="$1"
        if [ "$space" -ge 80 ]; then
                echo -e "WARNING"
        else
                echo -e "OK"
        fi
}

times=$(date)
uptime=$(uptime -p)
diskspace=$(df / | tail -n 1 | awk '{print $5 }' | cut -d'%' -f1)
ramy=$(free --mega | grep Mem | awk '{print $2 }')
ramk=$(free --mega | grep Mem | awk '{print $7}')
disk_status=$(DISK "$diskspace")

echo "Current time: $times"
echo "Server's uptime: $uptime"
echo "Current server's diskspace: $diskspace %"
echo "Server's RAM: $ramy MB"
echo "Server's RAM left $ramk MB"
echo "Disk space status: $disk_status"

# Tests which were needed
# DISK "50"
# DISK "80"
# DISK "90"

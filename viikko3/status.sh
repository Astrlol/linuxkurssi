#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1

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

sed -e "s/{{TIME}}/$times/g" \
    -e "s/{{UPTIME}}/$uptime/g" \
    -e "s/{{DISK}}/$diskspace/g" \
    -e "s/{{DISK_STATUS}}/$disk_status/g" \
    -e "s/{{RAM_TOTAL}}/$ramy/g" \
    -e "s/{{RAM_AVAILABLE}}/$ramk/g" \
    template.html > /var/www/html/viikko3/index.html.tmp \
    && mv /var/www/html/viikko3/index.html.tmp /var/www/html/viikko3/index.html

# Tests which were needed
# DISK "50"
# DISK "80"
# DISK "90"

#!/usr/bin/env bash
# Make a backup of server A's /var/www/html to server B
# Runs on B's user to backup over cron every hour

set -uo pipefail
umask 077

A_IP='192.168.1.33'
WHERETO="/srv/varmuuskopiot/nettisivu"
LOG="/srv/varmuuskopiot/varmuuskopio.log"
KEEP=24

DATE=$(date +%Y-%m-%d_%H%M)
LOGGING="$WHERETO/nettisivu-$DATE.tar.gz"

write() {
	echo "$(date '+%Y-%m-%d_%H%M:%S') $1" >> "$LOG"
}

ssh -o BatchMode=yes -o ConnectTimeout=10 varmuuskopio@"$A_IP" \
	"tar -czf - -C /var/www/ html" > "$LOGGING.inprogress"

SPACE=$?

if [ "$SPACE" -le 1 ] && [ -s "$LOGGING.inprogress" ]; then
	mv "$LOGGING.inprogress" "$LOGGING"
	SIZE=$(du -h "$LOGGING" | cut -f1)
	write "OK $LOGGING ($SIZE, tar-code $SPACE)"
else
	rm -f "$LOGGING.inprogress"
	write "FAIL (ERROR CODE $SPACE)"
	exit 1
fi

ls -1t "$WHERETO"/nettisivu-*.tar.gz | tail -n +$((KEEP + 1)) | xargs -r rm -f --

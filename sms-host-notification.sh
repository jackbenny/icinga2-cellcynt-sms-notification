#!/bin/bash
# Maintained by Jack-Benny Persson <jack-benny@cyberinfo.se>
# Released under GPLv2+
# Thanks to Icinga GmbH

source /etc/icinga2/cellsyntuser.sh

## Function helpers
Usage() {
cat << EOF

Required parameters:
  -4 HOSTADDRESS (\$host.address\$)
  -6 HOSTADDRESS6 (\$host.address6\$)
  -l HOSTNAME (\$host.name\$)
  -o HOSTOUTPUT (\$host.output\$)
  -p CONTACTPAGER (\$user.pager\$)
  -s HOSTSTATE (\$host.state\$)
  -t NOTIFICATIONTYPE (\$notification.type\$)

EOF
}

Help() {
  Usage;
  exit 0;
}

Error() {
  if [ "$1" ]; then
    echo $1
  fi
  Usage;
  exit 1;
}

## Main
while getopts 4:6:p:l:o:s:t: opt
do
  case "$opt" in
    4) HOSTADDRESS=$OPTARG ;;
    6) HOSTADDRESS6=$OPTARG ;;
    h) Help ;;
    l) HOSTNAME=$OPTARG ;; # required
    o) HOSTOUTPUT=$OPTARG ;; # required
    p) CONTACTPAGER=$OPTARG ;; # required
    s) HOSTSTATE=$OPTARG ;; # required
    t) NOTIFICATIONTYPE=$OPTARG ;; # required
   \?) echo "ERROR: Invalid option -$OPTARG" >&2
       Error ;;
    :) echo "Missing option argument for -$OPTARG" >&2
       Error ;;
    *) echo "Unimplemented option: -$OPTARG" >&2
       Error ;;
  esac
done

shift $((OPTIND - 1))

/bin/echo "http://se-1.cellsynt.net/sms.php?username=$username&password=$password&destination=$CONTACTPAGER&type=text&allowconcat=6&text=Notification%20Type:%20$NOTIFICATIONTYPE%0AHost:%20$HOSTNAME%0AState:%20$HOSTSTATE%0AAddress:%20$HOSTADDRESS%20$HOSTADDRESS6%0AAdditional%20Info:%20$HOSTOUTPUT&originatortype=alpha&originator=CyberInfo" | sed 's/ /%20/g' | /usr/bin/wget -i - -O /tmp/sms_log

#!/bin/bash
logdir=/tmp/.testy #/path/to/logdir, change it
installdir=/mnt/sdcard/bin/henet #/path/to/henet, change it
cronfile=/etc/cron.d/henet
henet="$0"

if [ -e "$cronfile" ] ; then
	printf "" ; else
	echo "installing cron"	;
	echo "*/15 * * * * root \""$henet"\"" > /etc/cron.d/henet ;
	/etc/init.d/cron restart	;
    fi
	
if [ -e "${logdir}"/log.txt ] ; then
	"${installdir}"/henet-main.sh &> "${logdir}"/log.txt ; else
	mkdir "${logdir}" ; 
	touch "${logdir}"/log.txt ; 
	"${installdir}"/henet-main.sh &> "${logdir}"/log.txt ;
	fi

exit 0

#!/bin/bash
logdir=/tmp/.testy
DIR=/path/to/henet

if [ -e "${logdir}"/log.txt ] ; then
	"${DIR}"/henet-main.sh &> "${logdir}"/log.txt ; else
	mkdir "${logdir}" ; 
	touch "${logdir}"/log.txt ; fi

"${DIR}"/henet-main.sh &> "${logdir}"/log.txt
exit 0
    
    
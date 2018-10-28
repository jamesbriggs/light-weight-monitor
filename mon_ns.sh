#!/bin/bash

# Program: mon_ns.sh
# Purpose: light-weight nameserver monitoring script
# Author: James Briggs, USA
# Env: linux bash
# Usage: ./mon_ns.sh
# Note: also illustrates advanced bash error handling, and arithmetic and date calculations

set -e

trap "exit" INT

while true
   do
   f=`grep '^nameserver ' /etc/resolv.conf`
   for ns in $f; do
      epoch=`date +%s`
      if [[ $ns == 'nameserver' ]]; then
         continue
      fi
      ts=$(date +%s%N)
      out=`dig @${ns} yahoo.com +tries=1 +time=2 +short | head -1`
      tt=$((($(date +%s%N) - $ts)/1000000))
      res="success"
      if [[ $out == "" ]]; then
         res="failed"
      fi
      echo "$epoch,$ns,$res,$tt"
      >&2 echo "notice: res=$res"
   done
   sleep 3600
done

set +e

exit 0

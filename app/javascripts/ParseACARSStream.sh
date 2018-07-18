#!/bin/bash
while read line
do
  if echo "$line" | grep -q "^\["
    then
      echo "$line" > /tmp/acarsmsg.txt
    else
      echo "$line" >> /tmp/acarsmsg.txt
  fi

  if test ${#line} = 0 
    then
      ./AddACARSMessage.sh /tmp/acarsmsg.txt
      sleep $[ ( $RANDOM % 10 )  + 1 ]s
    fi
done < "${1:-/dev/stdin}"

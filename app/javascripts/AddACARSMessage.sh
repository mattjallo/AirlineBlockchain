#!/bin/bash
. ~/.bash_profile
cd /home/mattjallo/Code/ABP/app/javascripts
TIMESTAMP=`cat $1 | grep -o "^\[.*$" | grep -o "[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}[[:space:]][0-9]\{2\}\:[0-9]\{2\}\:[0-9]\{2\}" | dateutils.dconv -i "%d/%m/%Y %H:%M:%S" -f %s`
CHANNEL=`cat $1 | grep -o "^\[\#[0-9]*[[:space:]]" | grep -o "[0-9]"`
MODE=`cat $1 | grep -o "^Mode[[:space:]]\:[[:space:]][0-9]*" | grep -o "[0-9]*"`
LABEL=`cat $1 | grep -o "Label[[:space:]]\:[[:space:]][0-9]*" | grep -o "[0-9]*"`
IDSTR=`cat $1 | grep -o "Id[[:space:]]\:[[:space:]].[[:space:]]" | head -c 6 | tail -c 1`
ACK=`cat $1 | grep -o "Ack[[:space:]]\:[[:space:]][0-9]*" | grep -o "[0-9]*"`
ACREG=`cat $1 | grep -o "Aircraft reg\:[[:space:]].*[[:space:]]Flight" | head -c -8 | cut -c 15-`
FLIGHTID=`cat $1 | grep -o "Flight id\:[[:space:]].*$" | cut -c 12-`
NOSTR=`cat $1 | grep -o "^No\:[[:space:]].*$" | cut -c 5-`
MESSAGE=`cat $1 | grep -v "^\[\#\|^Mode\|^Aircraft\|No\:\|^[[:space:]]*$" | cat | tr '\n\r' ' '`
B=`cat $1 | grep -o "F\:[0-9]*\.*[0-9]*[[:space:]]" | grep -o "[0-9]*\.*[0-9]*" | head -c 1`
LVL=`cat $1 | grep -o "L\:[0123456789\-]*[[:space:]]" | cut -c 3-`
ERR=`cat $1 | grep -o "E\:[0123456789][\\\\)]" | grep -o "[0-9]"`
/opt/node/bin/truffle exec AddACARSMessage2.js -t $TIMESTAMP -c $CHANNEL -i $IDSTR -e $ERR -l $LVL -m $MODE -a $ACREG -k $ACK -b $LABEL -d $B -n $NOSTR -f $FLIGHTID -g "$MESSAGE"
#echo "$TIMESTAMP" "$CHANNEL" "$IDSTR" "$ERR" "$LVL" "$MODE" "$ACREG" "$ACK" "$LABEL" "$B" "$NOSTR" "$FLIGHTID" "$MESSAGE"


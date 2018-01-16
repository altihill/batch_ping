#!/bin/bash
ips=$( grep -o '\([0-9]*\.\)\{3\}[0-9]*' $1 )
bestip=
minlag=10000
num=$( wc -w <<< $ips )
idx=0
prc=0
echo "IP,LAG,PKTLOSS">>"${1/%.*/_stat.csv}"
for ip in $ips
do
    (( idx+=100 ))
    prc=$( bc <<< "scale=1; $idx/$num" )
    echo -en " Evaluating DNS: $ip Overall Process: $prc % \r"
    stat=$( ping -c 5 -i 0.1 -t 2 -W 300 -q $ip )
    pktloss=$( sed -n 's/.* \([0-9]*\.[0-9]\)% packet loss.*/\1/p' <<< $stat )
    lag=$( sed -n 's/.*= [0-9]*\.[0-9]*\/\([0-9]*\.[0-9]*\).*/\1/p' <<< $stat )
    if [ -z $lag ]
    then
        echo -en '                                                        \r'
        echo -e "$ip\t\ttimeout"
    elif (( $( bc <<< "$pktloss == 0 && $lag < $minlag" ) ))
    then
        bestip=$ip
        minlag=$lag
        echo -en '                                                        \r'
        echo -e "$ip\t$lag ms\t$pktloss%"
    else
        echo -en '                                                        \r'
        echo -e "$ip\t$lag ms\t$pktloss%"
    fi
    echo "$ip,$lag,$pktloss">>"${1/%.*/_stat.csv}"
done
echo "=========================================="
echo -e "Best DNS: $bestip\t$minlag ms"
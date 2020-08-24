#!/bin/bash

# get host argument from user and store in var host
while getopts ":h:" opt; do
  case ${opt} in
    h )
      host=$OPTARG
      ;;
    \? )
      echo "Usage: myscan -h <target host>"; exit
      ;;
    : )
      echo "Invalid usage: missing host argument"; exit
      ;;
  esac
done

# no args provided
if (( $OPTIND == 1 )); then
   echo "Usage: myscan -h <target host>"; exit
fi

# if scans directory DNE, create
scansdir="${host}_scans"
[ ! -d "./$scansdir" ]
if (($? == 0)); then
  mkdir -v $scansdir
  if (($? == 1)); then
    echo "Unable to make directory $scansdir due to lack of write permissions in current directory."
    exit
  fi
fi


# start scanning
echo "scanning target $host"

# top 100 scan tcp
nmap -oX "${scansdir}/tcp_top10_scan.xml" -T4 --top-ports 100 -Pn -A $host &
wait
echo "wrote scan results to \"${scansdir}/tcp_top10_scan\""

# top 100 scan udp
#nmap -oX "${scansdir}/tcp_top10_scan.xml" -T4 --top-ports 100 -Pn -A $host

# all ports tcp
echo "scanning all TCP ports"
nmap -oX "${scansdir}/tcp_top10_scan.xml" -T4 -p- -Pn -A $host &


# all ports udp
#nmap -oX "${scansdir}/tcp_top10_scan.xml" -T4 --top-ports 100 -Pn -A $host

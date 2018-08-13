#!/bin/bash

function ping_stats {
  ping -c 60 "$1" | grep round-trip | cut -d" " -f4 | sed 's/\//,/g'
}

function speed_test {
  curl -m 120 -o /dev/null -s -w "%{http_code},%{size_download},%{speed_download}" "$1"
}

echo "provider,location,ping min,avg,max,stddev,http_code,size_download,speed_download"
while IFS=, read -r provider location url
do
  host=`echo $url | cut -d/ -f3`
  echo -n "$provider,$location,"
  echo -n `ping_stats "$host"`,
  echo `speed_test "$url"`
done < providers.csv

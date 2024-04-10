#!/bin/bash

rm -f known_hosts.tmp

for host in "$@"; do
  echo "Collecting host key for $host"
  ssh-keyscan -H "$host" >> known_hosts.tmp
done

sort -u known_hosts.tmp >> ~/.ssh/known_hosts
rm -f known_hosts.tmp
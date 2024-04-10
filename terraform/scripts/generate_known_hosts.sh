#!/bin/bash

rm -f known_hosts.tmp

for host in $(terraform output -json control-plane-ip-addresses | jq -r '.[]'); do
    echo "Collecting host key for $host"
    ssh-keyscan -H "$host" >> known_hosts.tmp
done

for host in $(terraform output -json worker-ip-addresses | jq -r '.[]'); do
    echo "Collecting host key for $host"
    ssh-keyscan -H "$host" >> known_hosts.tmp
done

sort -u known_hosts.tmp >> ~/.ssh/known_hosts
rm -f known_hosts.tmp
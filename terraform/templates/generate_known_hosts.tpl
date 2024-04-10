#!/bin/bash

rm -f known_hosts.tmp

% for ip in ips:
  echo "Collecting host key for ${ip}"
  ssh-keyscan -H "${ip}" >> known_hosts.tmp
% endfor

sort -u known_hosts.tmp >> ~/.ssh/known_hosts
rm -f known_hosts.tmp
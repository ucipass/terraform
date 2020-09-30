#!/bin/bash

printf '#/bin/bash!
curl "https://dynamicdns.park-your-domain.com/update?host=${host}&domain=${domain}&password=${password}"
' | cat > /tmp/dyndns.sh
chmod 700 /tmp/dyndns.sh
/tmp/dyndns.sh
hostnamectl set-hostname ${host}

#!/bin/bash

printf '\
curl "https://dynamicdns.park-your-domain.com/update?host=${host}&domain=${domain}&password=${password}"
' | cat > /tmp/dyndns.sh
chmod +x /tmp/dyndns.sh
/tmp/dyndns.sh

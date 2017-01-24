#!/bin/bash

set -euf -o pipefail

timeout_s=$1

echo "waiting ${timeout_s} seconds for cloud-init to finish..."
timeout ${timeout_s} /bin/bash -c 'until stat /var/lib/cloud/instance/boot-finished &>/dev/null; do echo -n "."; sleep 1; done' || echo "failed!"
echo "done!"
echo -n "cloud-init finished: "
cat /var/lib/cloud/instance/boot-finished

echo -n "waiting 2s more for good measure... "
sleep 2
echo "done!"

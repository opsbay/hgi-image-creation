#!/bin/bash

set -euf -o pipefail

echo -n "Cleaning up cloud-init instance data to force a new run on next boot... "
rm -rf /var/lib/cloud
echo "done!"


#!/bin/bash

set -euf -o pipefail

echo -n "Cleaning up cloud-init instance data to force a new run on next boot... "
( cd /var/lib/cloud/instance && rm -Rf * )
echo "done!"


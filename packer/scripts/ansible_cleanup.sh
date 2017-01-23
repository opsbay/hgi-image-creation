#!/bin/bash

set -euf -o pipefail

echo -n "Cleaning up ansible temporary directory ~/.ansible/tmp... "
rm -rf ~/.ansible/tmp
echo "done!"


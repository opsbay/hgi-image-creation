#!/bin/csh

echo "waiting for cloud-init to finish..."
while ( { stat /run/cloud-init/result.json >& /dev/null } == 0 )
  echo -n "."
  sleep 1
end

echo "cloud-init finished: "
cat /run/cloud-init/result.json


#!/bin/bash

service=$1

echo -n "stopping ${service}.timer... "
systemctl stop ${service}.timer
echo "done!"

echo -n "disabling ${service}.timer... "
systemctl disable ${service}.timer
echo "done!"

echo -n "stopping ${service}.service... "
systemctl stop ${service}.service
echo "done!"

echo -n "killing ${service}.service... "
systemctl kill --kill-who=all ${service}.service
echo "done!"

# wait until `apt-get updated` has been killed
echo -n "waiting for ${service}.service to really be dead..."
while ! (systemctl list-units --all ${service}.service | fgrep -q dead)
do
  sleep 1;
  echo -n "."
done
echo " done!"


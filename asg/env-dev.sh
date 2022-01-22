#!/bin/bash

for comp in catalogue user cart shipping payment ; do
  if [ -f /etc/systemd/system/$i.service ]; then
    sed -i -e 's|ENV|dev|' /etc/systemd/system/$i.service
    systemctl daemon-reload
    systemctl enable $comp
    systemctl restart $comp
  fi
done

if [ -f /etc/nginx/default.d/roboshop.conf ]; do
  sed -i -e 's|ENV|dev|' /etc/nginx/default.d/roboshop.conf
  systemctl restart nginx
done

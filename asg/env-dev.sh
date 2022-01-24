#!/bin/bash

for comp in catalogue user cart shipping payment ; do
  if [ -f /etc/systemd/system/$comp.service ]; then
    sed -i -e 's|ENV|dev|' /etc/systemd/system/$comp.service
    systemctl daemon-reload
    systemctl enable $comp
    systemctl restart $comp
  fi
done

if [ -f /etc/nginx/default.d/roboshop.conf ]; then
  sed -i -e 's|ENV|dev|' /etc/nginx/default.d/roboshop.conf
  systemctl restart nginx
fi

#!/bin/sh

configPath=/etc/krakend/krakend.json

if [ -n "${CONFIG_URL}" ]; then
  curl "${CONFIG_URL}" -o $configPath
fi

exec /usr/bin/krakend run -d -c $configPath

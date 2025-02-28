#!/bin/sh

configPath=/etc/krakend/krakend.json

if [ -n "${CONFIG_URL}" ]; then
  curl "${CONFIG_URL}" -o $configPath
fi

/usr/bin/krakend run -c $configPath

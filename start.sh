#!/bin/sh
set -eu

configPath=/etc/krakend/krakend.json

if [ -z "${CONFIG_URL:-}" ]; then
  echo "ERROR: CONFIG_URL is not set; refusing to start without config." >&2
  exit 1
fi

# Можно переопределить через env:
# CONFIG_WAIT_TIMEOUT=0  -> ждать бесконечно
# CONFIG_WAIT_TIMEOUT>0  -> таймаут в секундах
# CONFIG_WAIT_INTERVAL   -> пауза между попытками
CONFIG_WAIT_TIMEOUT="${CONFIG_WAIT_TIMEOUT:-0}"
CONFIG_WAIT_INTERVAL="${CONFIG_WAIT_INTERVAL:-2}"

tmpConfig="${configPath}.tmp"
start_ts="$(date +%s)"

echo "Fetching KrakenD config from: ${CONFIG_URL}"
while :; do
  # -f: падать на HTTP 4xx/5xx
  # -S: показывать ошибки
  # -s: тихо (без прогресса)
  if curl -fsS "${CONFIG_URL}" -o "${tmpConfig}" && [ -s "${tmpConfig}" ]; then
    mv -f "${tmpConfig}" "${configPath}"
    echo "Config downloaded to ${configPath}"
    break
  fi

  rm -f "${tmpConfig}" || true

  if [ "${CONFIG_WAIT_TIMEOUT}" -gt 0 ]; then
    now_ts="$(date +%s)"
    elapsed="$((now_ts - start_ts))"
    if [ "${elapsed}" -ge "${CONFIG_WAIT_TIMEOUT}" ]; then
      echo "ERROR: Timeout waiting for API (${CONFIG_WAIT_TIMEOUT}s). Not starting KrakenD." >&2
      exit 1
    fi
  fi

  echo "API not available yet, retrying in ${CONFIG_WAIT_INTERVAL}s..."
  sleep "${CONFIG_WAIT_INTERVAL}"
done

exec /usr/bin/krakend run -d -c "${configPath}"



##!/bin/sh
#
#configPath=/etc/krakend/krakend.json
#
#if [ -n "${CONFIG_URL}" ]; then
#  curl "${CONFIG_URL}" -o $configPath
#fi
#
#exec /usr/bin/krakend run -d -c $configPath

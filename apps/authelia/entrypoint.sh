#!/usr/bin/env sh

sigint_handler()
{
  kill "${PID}"
  exit
}

generate_config()
{
  yq eval-all ". as \$item ireduce ({}; . *+ \$item )" /config/*.y*ml > /tmp/configuration.yaml
}

count_configs()
{
  find /config -name "*.yaml" | wc -l
}

trap sigint_handler INT

generate_config
COUNT="$(count_configs)"

while true; do
  exec "$@" &
  PID=$!

  while [ "$(count_configs)" -eq "${COUNT}" ]; do
    kill -0 "${PID}" 2> /dev/null || exit 1
    sleep 1
  done

  generate_config
  kill "${PID}"
  COUNT="$(count_configs)"
done

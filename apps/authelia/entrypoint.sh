#!/usr/bin/env sh

sigint_handler()
{
  kill "${PID}"
  exit
}

generate_config()
{
  # authelia 4.38 introduced templating engine, which breaks yq - we need to escape it
  MASK="$(head -n 20 /dev/urandom | sha512sum)"
  mkdir -p /tmp/config
  for f in /config/*.y*ml; do
    sed "s/{{/${MASK}/g" "${f}" > /tmp/config/"$(basename "${f}")"
  done
  yq eval-all ". as \$item ireduce ({}; . *+ \$item )" /tmp/config/*.y*ml > /tmp/configuration.yaml
  sed -i'' "s/${MASK}/{{/g" /tmp/configuration.yaml
  rm -rf /tmp/config
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

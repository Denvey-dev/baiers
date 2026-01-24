#!/bin/sh

echo "[SETUP] Waiting for Elasticsearch availability..."

until curl -s -u elastic:${ELASTIC_PASSWORD} http://elasticsearch:9200/_cluster/health | grep -q '"status":"green"\|"status":"yellow"'; do
    echo "[SETUP] Elasticsearch is initializing... sleeping 5sss"
    sleep 5
done

echo "[SETUP] Elasticsearch is HEALTHY. Configuring security..."

response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -u elastic:${ELASTIC_PASSWORD} \
     -H "Content-Type: application/json" \
     http://elasticsearch:9200/_security/user/kibana_system/_password \
     -d "{\"password\":\"${KIBANA_PASSWORD}\"}")

if [ "$response" -eq 200 ]; then
    echo "[SETUP] SUCCESS: Password for 'kibana_system' updated."
else
    echo "[SETUP] ERROR: Failed to set password. HTTP Code: $response"
    exit 1
fi

echo "[SETUP] Configuration complete. Exiting."
exit 0
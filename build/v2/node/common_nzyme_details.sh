#!/bin/bash
export PATH="/usr/local/bin/nzyme:$PATH"
export POSTGRES_HOST=${POSTGRES_HOST:-localhost}
export POSTGRES_DB=${POSTGRES_DB:-nzyme}
export POSTGRES_USER=${POSTGRES_USER:-nzyme}
export NZYME_NODE=${NZYME_NODE:-nzyme-node-01}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:?Set POSTGRES_PASSWORD before starting Nzyme}
export NTP_SERVER=${NTP_SERVER:-pool.ntp.org}
export VERSION_CHECKS=${VERSION_CHECKS:-true}
export REST_LISTEN_URI=${REST_LISTEN_URI:-"https://127.0.0.1:22900/"}
export HTTP_EXTERNAL_URI=${HTTP_EXTERNAL_URI:-"https://127.0.0.1:22900/"}
export REPORT_PROCESSOR_POOL_SIZE=${REPORT_PROCESSOR_POOL_SIZE:-3}
export SESSION_TIMEOUT_SECONDS=${SESSION_TIMEOUT_SECONDS:-43200}
export INITIAL_HEAP_SIZE_IN_GB=${INITIAL_HEAP_SIZE_IN_GB:-1}
export MAX_HEAP_SIZE_IN_GB=${MAX_HEAP_SIZE_IN_GB:-1}
export NZYME_LOG_FILE=${NZYME_LOG_FILE:-"/var/log/nzyme/nzyme.log"}
export NODE_ID=${NODE_ID:-"550e8400-e29b-41d4-a716-446655440000"}

announce() {
     lines="***************************************"
     echo $lines 
     echo $1
     echo $lines
}

envsubst < /etc/nzyme/nzyme.conf.template > /etc/nzyme/nzyme.conf

# Configuration for the heap 
# See https://docs.nzyme.org/getting-started/installation/ubuntu-server-2204/#configure-nzymeconf)
announce "Configuring heap size"
echo -n 'NZYME_JAVA_OPTS="-Xms${INITIAL_HEAP_SIZE_IN_GB}g -Xmx${MAX_HEAP_SIZE_IN_GB}g -XX:-OmitStackTraceInFastThrow"' \
     > /etc/default/nzyme

announce "Setting node ID"
echo -n "${NODE_ID}" > /usr/share/nzyme/node_id

#!/bin/bash
set -e;

function elastic_schema_drop(){ compose_run 'schema' node scripts/drop_index "$@" || true; }
function elastic_schema_create(){ compose_run 'schema' node scripts/create_index; }
function elastic_start(){
  mkdir -p $DATA_DIR/elasticsearch
  chown $DOCKER_USER $DATA_DIR/elasticsearch
  compose_exec up -d elasticsearch
}

function elastic_stop(){ compose_exec kill elasticsearch; }

register 'elastic' 'drop' 'delete elasticsearch index & all data' elastic_schema_drop
register 'elastic' 'create' 'create elasticsearch index with pelias mapping' elastic_schema_create
register 'elastic' 'start' 'start elasticsearch server' elastic_start
register 'elastic' 'stop' 'stop elasticsearch server' elastic_stop

# to use this function:
# if test $(elastic_status) -ne 200; then
function elastic_status(){ curl --output /dev/null --silent --write-out "%{http_code}" "http://${ELASTIC_HOST:-localhost:9200}" || true; }

# the same function but with a trailing newline
function elastic_status_newline(){ echo $(elastic_status); }
register 'elastic' 'status' 'HTTP status code of the elasticsearch service' elastic_status_newline

function elastic_wait(){
  echo 'waiting for elasticsearch service to come up';
  retry_count=30

  i=1
  while [[ "$i" -le "$retry_count" ]]; do
    if [[ $(elastic_status) -eq 200 ]]; then
      echo
      exit 0
    fi
    sleep 2
    printf "."
    i=$(($i + 1))
  done

  echo
  echo "Elasticsearch did not come up, check configuration"
  exit 1
}

register 'elastic' 'wait' 'wait for elasticsearch to start up' elastic_wait

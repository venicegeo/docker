#!/bin/bash
set -e;

# per-source downloads
function download_wof(){ compose_run 'whosonfirst' npm run download }
function download_oa(){ compose_run 'openaddresses' './bin/download'; }
function download_osm(){ compose_run 'openstreetmap' './bin/download'; }
function download_geonames(){ compose_run 'geonames' './bin/download'; }
function download_tiger(){ compose_run 'interpolation' './bin/download-tiger'; }
function download_transit(){ compose_run 'transit' './bin/download'; }

register 'download' 'wof' '(re)download whosonfirst data' download_wof
register 'download' 'oa' '(re)download openaddresses data' download_oa
register 'download' 'osm' '(re)download openstreetmap data' download_osm
register 'download' 'tiger' '(re)download TIGER data' download_tiger
register 'download' 'transit' '(re)download transit data' download_transit

# download all the data to be used by imports
function download_all(){
  download_wof &
  download_oa &
  download_osm &

  if [[ "$ENABLE_GEONAMES" == "true" ]]; then
    download_geonames &
  fi

  download_tiger &
  download_transit &
  wait
}

register 'download' 'all' '(re)download all data' download_all

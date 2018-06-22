#!/bin/bash
set -e;

# per-source downloads
function download_wof(){ compose_run 'whosonfirst' npm run download; }
function download_oa(){ compose_run 'openaddresses' npm run download; }
function download_osm(){ compose_run 'openstreetmap' npm run download; }
function download_tiger(){ compose_run 'interpolation' npm run download-tiger; }
function download_transit(){ compose_run 'transit' npm run download; }
function download_gndb(){ compose_run 'gndb' npm run download; }

register 'download' 'wof' '(re)download whosonfirst data' download_wof
register 'download' 'oa' '(re)download openaddresses data' download_oa
register 'download' 'osm' '(re)download openstreetmap data' download_osm
register 'download' 'tiger' '(re)download TIGER data' download_tiger
register 'download' 'transit' '(re)download transit data' download_transit
register 'download' 'gndb' '(re)download transit gndb' download_gndb

# download all the data to be used by imports
function download_all(){
  download_wof &
  download_oa &
  download_osm &
  download_tiger &
  download_transit &
  download_gndb &
  wait
}

register 'download' 'all' '(re)download all data' download_all

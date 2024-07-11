#!/bin/bash

set -exu

cp -iv infinidat.py \
  /usr/lib/python3.9/site-packages/cinder/volume/drivers/

pip3.9 install logbook==1.5.3 infinisdk

echo "Use credential for root OS user"
powervc-register -o list -r storage

cat >infinidat.properties<<EOF
[backend_defaults]
use_multipath_for_image_xfer = True
suppress_requests_ssl_warnings = True
san_thin_provision = True
san_password = password
san_login = admin
san_ip = ibox.local
infinidat_storage_protocol = FC
infinidat_pool_name = powervc
driver_use_ssl = True
image_volume_cache_enabled = False
EOF

echo "Use credential for root OS user"
powervc-register \
  -o add \
  -r storage \
  -d cinder.volume.drivers.infinidat.InfiniboxVolumeDriver \
  -n "InfiniBox FC Backend" \
  -p infinidat.properties

rm -f infinidat.properties

echo "Use credential for root OS user"
powervc-register -o list -r storage

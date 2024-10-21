#!/bin/bash
# Copyright 2024 Infinidat Ltd.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

set -exu

cp -iv infinidat.py \
  /usr/lib/python3.9/site-packages/cinder/volume/drivers/

pip3.9 install logbook==1.5.3 infinisdk

echo "Listing storage backends. Use credential for root OS user"
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

echo "Registering Infinidat FC backend. Use credential for root OS user"
powervc-register \
  -o add \
  -r storage \
  -d cinder.volume.drivers.infinidat.InfiniboxVolumeDriver \
  -n "InfiniBox FC Backend" \
  -p infinidat.properties

rm -f infinidat.properties

echo "Listing storage backends. Use credential for root OS user"
powervc-register -o list -r storage

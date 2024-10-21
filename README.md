# INFINIDAT InfiniBox Cinder Volume Driver for PowerVC 2.2.0

## Steps to deploy the INFINIDAT InfiniBox Cinder Volume Driver as a pluggable storage


* Clone the repository
```
% git clone -b powervc-2.2 --single-branch git@github.com:Infinidat/infinidat-powervc-cinder.git 
% cd infinidat-powervc-cinder
```
* Edit the `infinidat.sh` file and modify the configuration options:
  - `san_ip` - the management IP address of FQDN of the INFINIDAT InfiniBox storage host
  - `san_login` - user name to access the  INFINIDAT InfiniBox storage host
  - `san_password` - password to access the  INFINIDAT InfiniBox storage host
  - `infinidat_pool_name` - storage pool name
For example:
```
% vi infinidat.sh
[backend_defaults]
use_multipath_for_image_xfer = True
suppress_requests_ssl_warnings = True
san_thin_provision = True
san_password = password
san_login = admin
san_ip = ibox.local
infinidat_storage_protocol = FC
infinidat_pool_name = pool
driver_use_ssl = True
image_volume_cache_enabled = False
```
* Run the `infinidat.sh` sript to install all required dependencies and register the INFINIDAT InfiniBox Cinder Volume Driver as a pluggable storage:
```
# source ~/powervcrc
# bash infinidat.sh 
+ cp -iv infinidat.py /usr/lib/python3.9/site-packages/cinder/volume/drivers/
cp: overwrite '/usr/lib/python3.9/site-packages/cinder/volume/drivers/infinidat.py'? y
'infinidat.py' -> '/usr/lib/python3.9/site-packages/cinder/volume/drivers/infinidat.py'

+ pip3.9 install logbook==1.5.3 infinisdk
...

+ powervc-register -o list -r storage

Name                     Display Name             Type
====                     ============             ====
22d988e478d37011eb8015fa9a49490478 SSP_host1                ssp

+ powervc-register -o add -r storage -d cinder.volume.drivers.infinidat.InfiniboxVolumeDriver -n 'InfiniBox FC Backend' -p infinidat.properties

The Storage Provider 'InfiniBox FC Backend' added to PowerVC.

+ powervc-register -o list -r storage

Name                     Display Name             Type
====                     ============             ====
22d988e478d37011eb8015fa9a49490478 SSP_host1                ssp
generic0                 InfiniBox FC Backend     generic
```

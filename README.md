# INFINIDAT InfiniBox Cinder volume driver as a pluggable storage for IBM PowerVC 2.3.1

## Supported Operation Systems
* Red Hat Enterprise Linux 8 `x86_64` and `ppc64le`
* Red Hat Enterprise Linux 9 `x86_64` and `ppc64le`

## Prerequisites
* Ensure that IBM PowerVC environment is up and running
* INFINIDAT InfiniBox storage is available in the management network or routed to the
management network
* INFINIDAT InfiniBox storage fibre channel ports are correctly configured
* INFINIDAT InfiniBox storage management interface is available from all the IBM PowerVC controller and compute nodes

## Install the INFINIDAT InfiniBox Cinder volume driver
It is required to install the INFINIDAT InfiniBox Cinder Volume Driver and INFINIDAT InfiniBox Python SDK. The RPM packages are publicly available and can be installed using the following command:
```
dnf copr enable -y deiter/powervc-2.3.1
dnf install -y python3.11-cinder-infinidat
```

## Create the configuration file
IBM PowerVC Pluggable Storage Driver properties can be defined in a `driver.properties` configuration file and used when registering the storage driver. For INFINIDAT InfiniBox storage, the required properties that need to be added are listed below:
```
cat > driver.properties <<EOF
[backend_defaults]
san_ip = ibox.local
san_login = admin
san_password = password
san_thin_provision = True
infinidat_storage_protocol = FC
infinidat_pool_name = pool
use_multipath_for_image_xfer = True
driver_use_ssl = True
suppress_requests_ssl_warnings = True
EOF
```

Description of parameters:
- `san_ip` - the management IP address of FQDN of the INFINIDAT InfiniBox storage host
- `san_login` - user name to access the  INFINIDAT InfiniBox storage host
- `san_password` - password to access the  INFINIDAT InfiniBox storage host
- `san_thin_provision` - use thin provisioning for SAN volumes
- `infinidat_storage_protocol` - SAN storage protocol
- `infinidat_pool_name` - the NFINIDAT InfiniBox storage pool name
- `use_multipath_for_image_xfer` - use multipath when attach and detach for volume to image and image to volume transfers
- `driver_use_ssl` - use SSL for connection to backend storage
- `suppress_requests_ssl_warnings` - suppress requests library SSL certificate warnings

## Register the pluggable driver
Run the `powervc-register` command to register the plugin and add the INFINIDAT InfiniBox storage as a storage provider to IBM PowerVC. This might take a few minutes to complete.
Note that this command must be run as root and will prompt for the root password.
The command and parameters look like this:
```
powervc-register -o add \
    -r storage \
    -d cinder.volume.drivers.infinidat.InfiniboxVolumeDriver \
    -n 'InfiniBox FC Backend' \
    -p driver.properties
```

## List the registered plugin
When the command completes, you can list the registered plugin:
```
powervc-register -o list -r storage

Name                     Display Name             Type
====                     ============             ====
generic0                 InfiniBox FC Backend     generic
```

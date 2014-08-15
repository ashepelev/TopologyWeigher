#/bin/bash

# Directory with nova source. Subdirectories are api,db,compute, etc.
nova_directory=/opt/stack/nova/nova

# Directory with novaclient source. Subdirectories are v1_1, v3, openstack, etc.
client_directory=/opt/stack/python-novaclient/novaclient

# Copy source

cp -r source/topology_weigher/* $nova_directory/scheduler/weights/
cp -r source/traffic_monitor/* $nova_directory/compute/monitors/

# Apply patch to nova with backup and non-reversed apply

patch -Nb $nova_directory/api/openstack/compute/servers.py < source/patches/nova-api-openstack-compute-servers.patch
patch -Nb $nova_directory/compute/api.py < source/patches/nova-compute-api.patch
patch -Nb $nova_directory/conductor/api.py < source/patches/nova-conductor-api.patch
patch -Nb $nova_directory/conductor/manager.py < source/patches/nova-conductor-manager.patch
patch -Nb $nova_directory/conductor/rpcapi.py < source/patches/nova-conductor-rpcapi.patch
patch -Nb $nova_directory/db/api.py < source/patches/nova-db-api.patch
patch -Nb $nova_directory/db/sqlalchemy/api.py < source/patches/nova-db-sqlalchemy-api.patch
patch -Nb $nova_directory/db/sqlalchemy/models.py < source/patches/nova-db-sqlalchemy-models.patch
patch -Nb $nova_directory/scheduler/filter_scheduler.py < source/patches/nova-scheduler-filter_scheduler.patch
patch -Nb $nova_directory/scheduler/host_manager.py < source/patches/nova-scheduler-host_manager.patch

# Apply patch to novaclient with backup and non-reversed apply

patch -Nb $client_directory/v1_1/shell.py < source/patches/novaclient-v1_1-shell.patch
patch -Nb $client_directory/v1_1/servers.py < source/patches/novaclient-v1_1-servers.patch

Author: Artem Shepelev

Email: shepelev.artem@gmail.com

Version: 0.1

Programming Language: Python

Dedicated project: OpenStack

This repository is created and filled up due to participation in the Google Summer of Code 2014 contest


##### DEPEND LIST #####

On compute node (hosting nova-compute):
- install python-pcapy
On cloud controller (hosting nova-scheduler):
- install python-yaml

##### INSTALL STEPS #####

1)  Stop the stack
    Be sure that nova-conductor are down (re-launching nova-conductor doesn't help)
    If you are using devstack - use Ctrl+A then \ at screen window - that will kill all screens

2)  In install-controller(compute).sh set the nova_directory and client_directory with your 
    deployment case

3)  Run install-controller(compute).sh
    That will copy all the source and make patches to source
    It will sync the database with new tables 

4)  Set up your /etc/nova/nova.conf on nodes
    Conf keywords are in "CONFIG STEPS" section
4.1)Create a directory with description of your topology
    The sample could be found in install/topology_sample
    You should set up topology_description_path in /etc/nova/nova.conf

5)  Launch the stack. Devstack: script rejoin-stack.sh
5.1)If you run stack services from the non-root user - stop the nova-compute service
    And launch it with root user. Devstack: cd /opt/stack/nova && sg libvirtd 'sudo /usr/local/bin/nova-compute --config-file /etc/nova/nova.conf'
    This step is important because the traffic monitor
    Uses libpcap library to sniff the traffic. That requires root capabilities.
    In future this sub-step will be remove with using oslo-rootwrap

##### CONFIG STEPS #####

Before launching stack:
in /etc/nova/nova.conf on compute nodes (nova-compute)
necessarily:

	traffic_enable_topology_statistics - BoolOpt or StrOpt param -default False
	specifying if the traffic statistics collector is enabled	

	traffic_sniffing_interface - StrOpt param - default None
	specifying the interface to sniff the traffic

optionally:

	refresh_traf_info - IntOpt - default 10 (secs)
	how often would collector send traffic metrics to db

	refresh_ping_info - IntOpt - default 10 (secs)
	how often would collector send ping metrics to db

	refresh_ping_make - IntOpt - default 5 (secs)
	how often would collector make the ping command

	ping_count - IntOpt - default 2
	How many times during one ping operation would be sended ICMP echoes

in /etc/nova/nova.conf on cloud contoller (nova-scheduler)
necessarily:

	traffic_enable_topology_statistics - BoolOpt or StrOpt param -default False
	specifying if the traffic statistics collector is enabled
	topology weigher won't work if it's disabled

	topology_description_path - StrOpt - default None
	path to directory, which contains nodes.yaml and edges.yaml files
	should be setted up before the scheduler starts
	optional if there is topology description in db
	Check the install/topology_sample/ to set your current
	topology description

optionally:

	topology_statistics_time - IntOpt param - default 3600 (secs)
	specifying how much of previous time would scheduler consider when
	getting the metrics

	channel_max_bandwidth - IntOpt param - default 100 (Mbits)
	specifying the bandwidth of channels in topology connections
	used to normalize the traffic metrics

	traffic_multiplier - IntOpt - default 5
	specifying the coefficient for traffic
	The more value is - the more scheduler will ignore 
	the disbalance load between nodes

##### CHECK STEPS #####

1)	Check the database.
	The installation will create 4 tables: nova.traffic_info, nova.ping_info, nova.node_info and nova.edge_info
	Tables nova.node_info and nova.edge_info will be loaded by scheduler
	Using your information given in the topology description .yaml files
	That you specified in topology_description_path

2)	After launching nova-compute agents - you can check the nova.traffic_info and nova.ping_info
	To see that statistics is loaded to db

3)	Use the command 'nova boot' to start the instance
	Specify the topology priorities using --topology_priority 'priority'
	The 'priority' looks like 'node_id':'priority'[,]
	The 'node_id' must be the same as the it setted up in nodes.yaml topology description file

##### TODO LIST #####

Make a rootwrap for traffic monitor that collects metric

Make it work with several network interfaces of compute node

Handle the case when compute node and cloud controller are hosted on one machine

Add more cases of using traffic statistics during scheduling (weighing)

Add using latency (ping) statistics during scheduling (weighing)

Work on optimization of traffic monitor for less CPU load

Work on adding traffic_monitor to non-compute nodes

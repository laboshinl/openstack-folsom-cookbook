#
# Cookbook Name:: cloud-common
# Recipe:: openvswitch
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
# 

package "openvswitch-switch" do
	action :install 
end

service "openvswitch-switch" do
	action :restart
end

package "vlan" do 
	action :install
end

# br-int is used for VM integration
bash "create-bridge-int" do
	not_if("ovs-vsctl list-br | grep br-int")
	code <<-CREATE
	ovs-vsctl add-br br-int
	CREATE
end

# br-eth1 is used for VM communication
bash "create-bridge-eth1" do
	not_if("ovs-vsctl list-br | grep br-eth1")
	code <<-CREATE
	ovs-vsctl add-br br-eth1
	CREATE
end

# add iface eth1 to br-eth1
bash "add-port-eth1" do
	not_if("ovs-vsctl list-ports br-eth1 | grep eth1")
	code <<-ADD
	ovs-vsctl add-port br-eth1 eth1
	ADD
end

package "quantum-plugin-openvswitch-agent" do
	action :install
end

template "/etc/quantum/quantum.conf" do
	source "quantum.conf.erb"
	owner "quantum"
	group "quantum"
	mode "0644"
end

template "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini" do
	source "ovs_quantum_plugin.ini.erb"
	owner "quantum"
	group "quantum"
	mode "0644"
end

service "quantum-plugin-openvswitch-agent" do
	action :restart
end





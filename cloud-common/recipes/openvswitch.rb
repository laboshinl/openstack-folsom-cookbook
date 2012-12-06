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

# br-ex is used for accessing internet.
bash "create-bridge-ex" do
	not_if("ovs-vsctl list-br | grep br-ex")
	code <<-CREATE
	ovs-vsctl add-br br-ex
	CREATE
end

# add iface eth0 to br-ex
bash "add-port-eth0" do
	not_if("ovs-vsctl list-ports br-ex | grep #{node[:controller][:public_interface]}")
	code <<-ADD
	ovs-vsctl add-port br-ex #{node[:controller][:public_interface]}
	ADD
end

# br-eth1 is used for VM communication
bash "create-bridge-eth1" do
	not_if("ovs-vsctl list-br | grep br-#{node[:controller][:private_interface]}")
	code <<-CREATE
	ovs-vsctl add-br br-#{node[:controller][:private_interface]}
	CREATE
end

# add iface eth1 to br-eth1
bash "add-port-eth1" do
	not_if("ovs-vsctl list-ports br-eth1 | grep #{node[:controller][:private_interface]}")
	code <<-ADD
	ovs-vsctl add-port br-#{node[:controller][:private_interface]} #{node[:controller][:private_interface]}
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





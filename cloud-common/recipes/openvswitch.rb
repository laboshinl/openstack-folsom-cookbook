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

package "openvswitch-brcompat" do 
	action :install
end

service "openvswitch-switch" do
	action :nothing
	supports :status => true, :restart => true, :start => true  
end

bash "blacklist_bridge" do
	code <<-REMOVE
	rmmod bridge
	echo "blacklist bridge" >> /etc/modprobe.d/blacklist.conf
	REMOVE
end

template "/etc/default/openvswitch-switch" do
	source "openvswitch-switch.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, resources(:service => "openvswitch-switch"), :immediately
end

bash "vlan-enable" do
	code <<-VLAN
	modprobe 8021q
	echo "8021q" >> /etc/modules
	VLAN
end

bash "create-bridge" do
	not_if("brctl show | brctl show | grep br-int")
	code <<-CREATE
	ovs-vsctl add-br br-int
	CREATE
end

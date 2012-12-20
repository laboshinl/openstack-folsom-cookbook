#
# Cookbook Name:: cloud-common
# Recipe:: openvswitch
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
# 

# Install packages
["openvswitch-switch", "openvswitch-brcompat", "vlan"].each do |pkg|
	package pkg do
		action :install
	end
end

# Enable brcompat module
template "/etc/default/openvswitch-switch" do
	source "openvswitch-switch_2.erb"
	owner "root"
	group "root"
	mode "0644"
end

# Remove bridge module if exists
template "/etc/init.d/openvswitch-switch" do
	source "openvswitch-switch.erb"
	owner "root"
	group "root"
	mode "0755"
end

# Restart openvswitch service
service "openvswitch-switch" do
	action :restart
end

# Create bridge br-int, which is used for VM integration
bash "create-bridge-int" do
	not_if("ovs-vsctl list-br | grep br-int")
	code <<-CREATE
	ovs-vsctl add-br br-int
	CREATE
end

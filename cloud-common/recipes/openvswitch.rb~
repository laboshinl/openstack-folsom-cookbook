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

template "/etc/default/openvswitch-switch" do
	source "openvswitch-switch_2.erb"
	owner "root"
	group "root"
	mode "0644"
end

template "/etc/init.d/openvswitch-switch" do
	source "openvswitch-switch.erb"
	owner "root"
	group "root"
	mode "0755"
end

service "openvswitch-switch" do
	action :restart
	supports :status => true, :restart => true, :start => true  
end

bash "create-bridge" do
	not_if("brctl show | brctl show | grep br-int")
	code <<-CREATE
	ovs-vsctl add-br br-int
	CREATE
end

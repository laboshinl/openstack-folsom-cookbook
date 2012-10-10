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

bash "create-bridge-int" do
	not_if("brctl show | brctl show | grep br-int")
	code <<-CREATE
	ovs-vsctl add-br br-int
	CREATE
end

bash "create-bridge-ex" do
	not_if("brctl show | brctl show | grep br-ex")
	code <<-CREATE
	ovs-vsctl add-br br-ex
	CREATE
end

bash "set-bridges" do 
	code <<-SET
	ovs-vsctl br-set-external-id br-ex bridge-id br-ex
	ovs-vsctl add-port br-ex eth2
	SET
end


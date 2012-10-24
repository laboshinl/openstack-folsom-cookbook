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
	not_if("ovs-vsctl list-br | grep br-int")
	code <<-CREATE
	ovs-vsctl add-br br-int
	CREATE
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

#bash "create-bridge-ex" do
#	not_if("ovs-vsctl list-br | grep br-ex")
#	code <<-CREATE
#	ovs-vsctl add-br br-ex
#	CREATE
#end

#bash "set-bridges" do 
#	not_if("ovs-vsctl list-ports br-ex | grep eth2")
#	code <<-SET
#	ovs-vsctl br-set-external-id br-ex bridge-id br-ex
#	ovs-vsctl add-port br-ex eth2
#	SET
#end


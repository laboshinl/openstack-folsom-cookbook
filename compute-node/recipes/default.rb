#
# Cookbook Name:: compute-node
# Recipe:: default
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

package "nova-compute" do
	action :install
end

template "/etc/nova/nova-compute.conf" do
	source "nova-compute.conf.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

template "/etc/nova/api-paste.ini" do
	source "api-paste.ini.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

template "/etc/nova/nova.conf" do
	source "nova.conf.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

service "libvirt-bin" do
	action :nothing
	supports :status => true, :restart => true, :start => true 
end

template "/etc/libvirt/qemu.conf" do
	source "qemu.conf.erb"
	owner "nova"
	group "nova"
	mode "0600"
	notifies :restart, resources(:service => "libvirt-bin"), :immediately
end

service "nova-compute" do
	action :restart
	supports :status => true, :restart => true, :start => true 
end

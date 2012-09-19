#
# Cookbook Name:: cloud-controller
# Recipe:: rabbitmq
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#
package "nova-cert" do
	action :install
end

package "nova-api" do
	action :install
end

package "nova-network" do
	action :install
end

package "nova-objectstore" do
	action :install
end

package "nova-volume" do 
	action :install
end 

package "nova-scheduler" do
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

service "nova-api" do
	action :restart
end

service "nova-network" do 
	action :restart
end

service "nova-scheduler" do
	action :restart
end

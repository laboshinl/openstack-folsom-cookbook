#
# Cookbook Name:: cloud-controller
# Recipe:: nova
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

package "nova-consoleauth" do
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

bash "database" do
	code <<-SQL
	nova-manage db sync
	SQL
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

service "nova-cert" do
	action :restart
end

service "nova-objectstore" do
	action :restart
end

service "nova-volume" do
	action :restart
end

bash "network" do
	code <<-CREATE
	nova-manage network create private 172.16.0.0/16 256 256
	CREATE
end 

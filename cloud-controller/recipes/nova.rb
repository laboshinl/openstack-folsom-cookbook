#
# Cookbook Name:: cloud-controller
# Recipe:: nova
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

packages = Array.[]("nova-cert", "nova-api", "nova-network", "nova-objectstore", "nova-volume", "nova-scheduler", "nova-consoleauth" )

$i=0;
$num=7;

begin
        package packages.at($i) do
                action :install
        end
        $i+=1;
end while $i < $num

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

$i=0;

begin
        service packages.at($i) do
                action :restart
        end
        $i+=1;
end while $i < $num

bash "network" do
	not_if("nova-manage network list | grep 172.16.0.0")
	code <<-CREATE
		nova-manage network create private 172.16.0.0/16 256 256
	CREATE
end 

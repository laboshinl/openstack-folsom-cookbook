#
# Cookbook Name:: cloud-controller
# Recipe:: nova
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

["nova-cert", "nova-api", "nova-scheduler", "nova-consoleauth", "nova-novncproxy", "nova-network", "novnc"].each do |pkg|
	package pkg do
		action :install
	end
end

template "/etc/nova/api-paste.ini" do
	source "nova/api-paste.ini.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

template "/etc/nova/nova.conf" do
	source "nova/nova.conf.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

bash "cloudpipe_image_id" do
	code <<-IMAGE	
	ID=$(source /tmp/adminrc.sh && glance index | grep cloudpipe | awk '{print $1}')
	sed -i "s/cloudpipe_image/$ID/g" /etc/nova/nova.conf
	IMAGE
end
template "/usr/share/pyshared/nova/cloudpipe/pipelib.py" do
	source "nova/pipelib.py"
	owner "root"
	group "root"
	mode "644"
end

bash "database" do
	code <<-SQL
		nova-manage db sync
	SQL
end 

directory "/home/nova" do
	owner "nova"
	group "nova"
	mode 0755
	recursive true
end
 

["nova-cert", "nova-api", "nova-scheduler", "nova-consoleauth", "nova-novncproxy", "nova-network"].each do |pkg|
	service pkg do
		action :restart
	end
end

bash "network" do
	not_if("nova-manage network list | grep 172.16.0.0")
	code <<-CREATE
		nova-manage network create private 172.16.0.0/16 256 256 --vlan=100 
	CREATE
end 

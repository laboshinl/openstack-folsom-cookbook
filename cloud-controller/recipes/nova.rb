#
# Cookbook Name:: cloud-controller
# Recipe:: nova
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

["nova-cert", "nova-api", "nova-scheduler", "nova-consoleauth", "nova-nova-novncproxy"].each do |pkg|
	package pkg do
		action :install
	end
end

["nova-common", "python-nova", "python-novaclient"].each do |pkg|
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

bash "database" do
	code <<-SQL
		nova-manage db sync
	SQL
end 

["nova-cert", "nova-api", "nova-scheduler", "nova-consoleauth", "nova-nova-novncproxy"].each do |pkg|
	service pkg do
		action :restart
	end
end


#
# Cookbook Name:: cloud-controller
# Recipe:: dashboard
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

["apache2", "memcached", "libapache2-mod-wsgi", "openstack-dashboard"].each do |pkg|
	package pkg do
		action :install
	end     
end

template "/etc/openstack-dashboard/local_settings.py" do
	source "dashboard/local_settings.py.erb"
	owner "root"
	group "root"
	mode "0644"
end

service "apache2" do
	action :restart
end

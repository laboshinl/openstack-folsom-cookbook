#
# Cookbook Name:: cloud-controller
# Recipe:: munin
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

%w[munin expect].each do |pkg|
	package pkg do
		action :install
	end
end

template "/etc/munin/apache.conf" do
	source "munin/apache.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

template "/etc/munin/munin.conf" do
	source "munin/munin.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

%x[expect -c 'spawn htpasswd -c /etc/munin/munin-htpasswd test; expect \"New password:\" {send \"#{node[:keystone][:password]}\r\"}; expect \"Re-type new password:\" {send \"#{node[:keystone][:password]}\r\"; interact}']

%w[apache2 munin-node].each do |srv|
	service srv do
		action :restart
	end
end
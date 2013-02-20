#
# Cookbook Name::cloud-compute
# Recipe::munin
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

%w[munin-node munin-plugins-extra].each do |pkg|
	package pkg do
		action :install
	end
end

template "/etc/munin/munin-node.conf" do
	source "munin-node.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

service "munin-node" do
	action :restart
end

#
# Cookbook Name:: cloud-common
# Recipe:: openvswitch
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
# 

template "/etc/sysctl.conf" do
	source "sysctl.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

bash "enable_forwarding" do
	code <<-ENABLE
	sysctl net.ipv4.ip_forward=1
	ENABLE
end

#
# Cookbook Name:: cloud-common
# Recipe:: interfaces
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
# 

bash "edit_interfaces" do
	not_if("grep br-ex /etc/network/interfaces")
	code <<-REPLACE
	sed -i 's/#{node[:controller][:public_interface]}/br-ex/g' /etc/network/interfaces
	sed -i 's/#{node[:controller][:private_interface]}/br-#{node[:controller][:private_interface]}/g' /etc/network/interfaces
	REPLACE
end

template "/tmp/interfaces" do
	source "interfaces.erb"
	owner "root"
	group "root"
	mode "644"
end

bash "append" do
	not_if("grep IFACE /etc/network/interfaces")
	code <<-APPEND
	cat /tmp/interfaces >> /etc/network/interfaces
	APPEND
end

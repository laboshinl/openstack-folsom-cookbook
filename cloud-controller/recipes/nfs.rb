#
# Cookbook Name:: cloud-controller
# Recipe:: nfs
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

package "nfs-kernel-server" do
	action :install
end

template "/etc/exports" do
	source "exports.erb"
	owner "root"
	group "root"
	mode "0644"
end

service "nfs-kernel-server" do
	action :restart
end


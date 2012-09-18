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

service "nfs-kernel-server" do
	action :nothing
	supports :status => true, :restart => true, :start => true 
end

directory "/var/export/nova" do
  owner "nova"
  group "nova"
  mode 0755
  recursive true
end

template "/etc/exports" do
	source "exports.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, resources(:service => "nfs-kernel-server"), :immediately
end



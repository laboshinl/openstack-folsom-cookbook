#
# Cookbook Name:: cloud-common
# Recipe:: nfs
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
# 

execute "apt-get update" do
	action :nothing
end

execute "apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 5EDB1B62EC4926EA" do
	not_if "apt-key export 'Canonical Cloud Archive'"
end

template "/etc/apt/sources.list" do
	owner "root"
	mode "0644"
	source "sources.list.erb"
	notifies :run, resources("execute[apt-get update]"), :immediately
end



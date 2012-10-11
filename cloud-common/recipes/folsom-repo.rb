#
# Cookbook Name:: cloud-common
# Recipe:: folsom-repo
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
# 

execute "apt-get update" do
	action :nothing
end

bash "addkey" do
	code <<-CODE
	gpg --keyserver keyserver.ubuntu.com --recv 3B6F61A6
	gpg --export --armor 3B6F61A6 > key.key
	apt-key add key.key
	rm key.key
	CODE
end
	 
template "/etc/apt/sources.list" do
	owner "root"
	mode "0644"
	source "sources.list.erb"
	notifies :run, resources("execute[apt-get update]"), :immediately
end



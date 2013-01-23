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

bash "addkeys" do
	code <<-CODE
	gpg --keyserver keyserver.ubuntu.com --recv EC4926EA
	gpg --export --armor EC4926EA | apt-key add -
	gpg --keyserver keyserver.ubuntu.com --recv C2458988
	gpg --export --armor C2458988 | apt-key add -
	CODE
end
	 
template "/etc/apt/sources.list" do
	owner "root"
	mode "0644"
	source "sources.list.erb"
	notifies :run, resources("execute[apt-get update]"), :immediately
end



#
# Cookbook Name:: cloud-controller
# Recipe:: glance
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "glance" do
	action :install
end

template "/etc/glance/glance-api-paste.ini" do
	source "glance-api-paste.ini.erb"
	owner "glance"
	group "glance"
	mode "0644"
end

template "/etc/glance/glance-registry-paste.ini" do
	source "glance-registry-paste.ini.erb"
	owner "glance"
	group "glance"
	mode "0644"
end

template "/etc/glance/glance-registry.conf" do
	source "glance-registry.conf.erb"
	owner "glance"
	group "glance"
	mode "0644"
end

template "/etc/glance/glance-api.conf" do
	source "glance-api.conf.erb"
	owner "glance"
	group "glance"
	mode "0644"
end

bash "db_sync" do
	code <<-SYNC
		glance-manage version_control 0
		glance-manage db_sync
	SYNC
end

service "glance-api" do
	action :restart 
end

service "glance-registry" do
	action :restart 
end


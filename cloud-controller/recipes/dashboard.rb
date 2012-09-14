#
# Cookbook Name:: cloud-controller
# Recipe:: novnc
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#
package "apache2" do
	action :install
end

package "memcached" do
	action :install
end

package "libapache2-mod-wsgi" do
	action :install
end

package "openstack-dashboard" do
	action :install
end

template "/etc/apache2/conf.d/openstack-dashboard.conf" do
  source "openstack-dashboard.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/openstack-dashboard/local_settings.py" do
  source "local_settings.py.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "apache2" do
action :restart
supports :status => true, :restart => true, :start => true

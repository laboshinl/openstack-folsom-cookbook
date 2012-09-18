#
# Cookbook Name:: cloud-controller
# Recipe:: keystone
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

package "keystone" do
  action :install
end

service "keystone" do
action :nothing
supports :status => true, :restart => true, :start => true 
end
 
template "/etc/keystone/keystone.conf" do
  source "keystone.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "keystone"), :immediately
end

template "/etc/keystone/default_catalog.templates" do
  source "default_catalog.templates.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "keystone"), :immediately
end

bash "db_sync" do
  code <<-SYNC
  keystone-manage db_sync
  SYNC
end

bash "create_users" do
code <<-USERS
  ADMIN_PASSWORD=#{node[:keystone][:password]}
  ADMIN_EMAIL=#{node[:keystone][:email]} 
  export SERVICE_TOKEN=#{node[:keystone][:token]} 
  export SERVICE_ENDPOINT="http://127.0.0.1:35357/v2.0"
  ADMIN_TENANT=$(keystone tenant-create --name=admin | awk '/ id / { print $4 }')
  ADMIN_USER=$(keystone user-create --name=admin \
                                    --pass="$ADMIN_PASSWORD" \
                                    --email=$ADMIN_EMAIL \
				    | awk '/ id / { print $4 }')
  ADMIN_ROLE=$(keystone role-create --name=$ADMIN_USER_NAME | awk '/ id / { print $4 }')
  keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $ADMIN_TENANT
USERS
end



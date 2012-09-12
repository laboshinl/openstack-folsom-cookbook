#
# Cookbook Name:: keystone
# Recipe:: default
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

package "keystone" do
  action :install
end

package "python-keystone" do
  action :install
end

package "python-keystoneclient" do
  action :install
end

package "python-mysqldb" do
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

bash "db_sync" do
  code <<-SYNC
  keystone-manage db_sync
  SYNC
end

bash "create_users" do
code <<-USERS
  ADMIN_TENANT_NAME=admin
  ADMIN_USER_NAME=admin
  ADMIN_PASSWORD=#{node[:keystone][:password]}
  ADMIN_EMAIL=#{node[:keystone][:email]} 
  export SERVICE_TOKEN=#{node[:keystone][:token]} 
  export SERVICE_ENDPOINT="http://127.0.0.1:35357/v2.0"
  SERVICE_TENANT_NAME="service"
  SERVICE_PASSWORD="service"
  ADMIN_TENANT=$(keystone tenant-create --name=$ADMIN_TENANT_NAME | awk '/ id / { print $4 }')
  SERVICE_TENANT=$(keystone tenant-create --name=$SERVICE_TENANT_NAME | awk '/ id / { print $4 }')
  DEMO_TENANT=$(keystone tenant-create --name=demo | awk '/ id / { print $4 }')
  INVIS_TENANT=$(keystone tenant-create --name=invisible_to_admin | awk '/ id / { print $4 }')

  ADMIN_USER=$(keystone user-create --name=$ADMIN_USER_NAME \
                                    --pass="$ADMIN_PASSWORD" \
                                    --email=$ADMIN_EMAIL \
				    | awk '/ id / { print $4 }')
  DEMO_USER=$(keystone user-create  --name=demo \
                                    --pass="$ADMIN_PASSWORD" \
                                    --email=demo@fix.me \
				    | awk '/ id / { print $4 }')

  ADMIN_ROLE=$(keystone role-create --name=$ADMIN_USER_NAME | awk '/ id / { print $4 }')
  KEYSTONEADMIN_ROLE=$(keystone role-create --name=KeystoneAdmin | awk '/ id / { print $4 }')
  KEYSTONESERVICE_ROLE=$(keystone role-create --name=KeystoneServiceAdmin | awk '/ id / { print $4 }')
  ANOTHER_ROLE=$(keystone role-create --name=anotherrole | awk '/ id / { print $4 }')

  keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $ADMIN_TENANT
  keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $DEMO_TENANT
  keystone user-role-add --user $DEMO_USER --role $ANOTHER_ROLE --tenant_id $DEMO_TENANT
  keystone user-role-add --user $ADMIN_USER --role $KEYSTONEADMIN_ROLE --tenant_id $ADMIN_TENANT
  keystone user-role-add --user $ADMIN_USER --role $KEYSTONESERVICE_ROLE --tenant_id $ADMIN_TENANT

  MEMBER_ROLE=$(keystone role-create --name=Member | awk '/ id / { print $4 }')
  keystone user-role-add --user $DEMO_USER --role $MEMBER_ROLE --tenant_id $DEMO_TENANT
  keystone user-role-add --user $DEMO_USER --role $MEMBER_ROLE --tenant_id $INVIS_TENANT

  NOVA_USER=$(keystone user-create --name=nova \
                                   --pass="$SERVICE_PASSWORD" \
                                   --tenant_id $SERVICE_TENANT \
                                   --email=nova@fix.me \
				   | awk '/ id / { print $4 }')
  keystone user-role-add --tenant_id $SERVICE_TENANT \
                         --user $NOVA_USER \
                         --role $ADMIN_ROLE

  GLANCE_USER=$(keystone user-create --name=glance \
                                     --pass="$SERVICE_PASSWORD" \
                                     --tenant_id $SERVICE_TENANT \
                                     --email=glance@fix.me \
				     | awk '/ id / { print $4 }')
  keystone user-role-add --tenant_id $SERVICE_TENANT \
                         --user $GLANCE_USER \
                         --role $ADMIN_ROLE
USERS
end



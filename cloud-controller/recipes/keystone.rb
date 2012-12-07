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
	action :restart
end
 
template "/etc/keystone/keystone.conf" do
	source "keystone/keystone.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

template "/etc/keystone/default_catalog.templates" do
	source "keystone/default_catalog.templates.erb"
	owner "root"
	group "root"
	mode "0644"
end

service "keystone" do
	action :restart
end

bash "db_sync" do
	code <<-SYNC
		keystone-manage db_sync
	SYNC
end

bash "create_users" do
	not_if("mysql -uroot -p#{node[:mysql][:password]} keystone -e 'SELECT * FROM user' | grep admin")
		code <<-USERS
  			export SERVICE_TOKEN=#{node[:keystone][:token]} 
  			export SERVICE_ENDPOINT="http://127.0.0.1:35357/v2.0"
  			ADMIN_TENANT=$(keystone tenant-create --name=admin | awk '/ id / { print $4 }')
			TEST_TENANT=$(keystone tenant-create --name=test | awk '/ id / { print $4 }')
  			ADMIN_USER=$(keystone user-create --name=admin --pass=#{node[:keystone][:password]} --email=#{node[:keystone][:email]} | awk '/ id / { print $4 }')
			TESTER_USER=$(keystone user-create --name=tester --pass=#{node[:keystone][:password]} --email=#{node[:keystone][:email]} | awk '/ id / { print $4 }')
  			ADMIN_ROLE=$(keystone role-create --name=admin | awk '/ id / { print $4 }')
			MEMBER_ROLE=$(keystone role-create --name=Member | awk '/ id / { print $4 }')
  			keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $ADMIN_TENANT
			keystone user-role-add --user-id $TESTER_USER --role-id $MEMBER_ROLE --tenant-id $TEST_TENANT
			cat >> /tmp/adminrc.sh << EOF
export OS_AUTH_URL=http://localhost:5000/v2.0
export OS_TENANT_ID=$ADMIN_TENANT
export OS_NO_CACHE=1
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=#{node[:keystone][:password]}		
		USERS
end



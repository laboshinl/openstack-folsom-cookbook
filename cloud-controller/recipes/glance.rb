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

bash "test_image" do
	code <<-UPLOAD
		. /root/stackrc
		RAMDISK=$(glance add name=debian6_ramdisk disk_format=ari container_format=ari is_public=True copy_from=http://195.208.117.179/debian6/initrd.img | awk '{print $6}')
		KERNEL=$(glance add name=debian6_kernel disk_format=aki container_format=aki is_public=True copy_from=http://195.208.117.179/debian6/vmlinuz | awk '{print $6}')
		glance add name=debian6 disk_format=ami container_format=ami is_public=True ramdisk_id=$RAMDISK kernel_id=$KERNEL copy_from=http://195.208.117.179/debian6/debian6.img
	UPLOAD
end

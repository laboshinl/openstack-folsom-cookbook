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


template "/etc/glance/glance-registry.conf" do
	source "glance/glance-registry.conf.erb"
	owner "glance"
	group "glance"
	mode "0644"
end

template "/etc/glance/glance-api.conf" do
	source "glance/glance-api.conf.erb"
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

#bash "image_upload" do
#	not_if(". /tmp/adminrc.sh && glance index | grep ubuntu12")
#	code <<-UPLOAD
#		. /tmp/adminrc.sh
#		RAMDISK=$(glance image-create --name ubuntu12_ramdisk --disk-format ari --container-format ari --is-public true --copy-from http://195.208.117.179/ubuntu1204/initrd.img-3.2.0-23-generic | grep id | awk '{print $4}')
#		KERNEL=$(glance image-create --name ubuntu12_kernel --disk-format aki --container-format aki --is-public true --copy-from http://195.208.117.179/ubuntu1204/vmlinuz-3.2.0-23-generic | grep id | awk '{print $4}')
#		glance image-create --name ubuntu12 --is-public true --disk-format ami --container-format ami --property kernel_id=$KERNEL --property ramdisk_id=$RAMDISK --copy-from http://195.208.117.179/ubuntu1204/ubuntu1204.img
#	UPLOAD
#end

bash "image_upload" do
	code <<-UPLOAD
		exist=$(glance index | grep -o "Ubuntu_12.04_LTS")
                if [ -n "$exist" ] ; then
                                echo "Already loaded, doing nothing"
                        else
                                glance add name="Ubuntu_12.04_LTS" is_public=true container_format=ovf disk_format=qcow2 copy_from=http://stackgeek.s3.amazonaws.com/ubuntu-12.04-server-cloudimg-amd64-disk1.img
                fi
		exist=$(glance index | grep -o "cloudpipe")
                if [ -n "$exist" ] ; then
                                echo "Already loaded, doing nothing"
                        else
                                glance add name="cloudpipe" is_public=true container_format=ovf disk_format=qcow2 copy_from=http://195.208.117.179/cloudpipe.img
                fi
	UPLOAD		
end

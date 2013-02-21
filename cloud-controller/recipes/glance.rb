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

bash "mount" do
	not_if("grep images /etc/fstab")
	code <<-MOUNT
        	echo "/dev/#{node[:controller][:vg_name]}/images /var/lib/glance ext4 rw,user,exec 0 0" >> /etc/fstab
		mount -a
		chown glance:glance /var/lib/glance -R
		chmod 755 /var/lib/glance -R
	MOUNT
end

service "glance-api" do
	action :restart 
end

service "glance-registry" do
	action :restart 
end

#bash "bug" do
#	code <<-FIX
#	find /usr/lib/python2.7/dist-packages/python_glanceclient* -name requires.txt -exec sed -i "s/0.2/0.5/g" {} \;
#	FIX
#end

bash "image_upload" do
	code <<-UPLOAD
		source /tmp/adminrc.sh
		exist=$(glance index | grep -o "Ubuntu_12.04_LTS")
                if [ -n "$exist" ] ; then
                                echo "Already loaded, doing nothing"
                        else
				glance image-create --name Ubuntu_12.04_LTS --is-public true --container-format bare --disk-format qcow2 --copy-from http://stackgeek.s3.amazonaws.com/ubuntu-12.04-server-cloudimg-amd64-disk1.img
                fi
		exist=$(glance index | grep -o "cloudpipe")
                if [ -n "$exist" ] ; then
                                echo "Already loaded, doing nothing"
                        else
				glance image-create --name cloudpipe --is-public true --container-format bare --disk-format qcow2 --copy-from http://195.208.117.179/cloudpipe/disk.img
                fi
	UPLOAD
end


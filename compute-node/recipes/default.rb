#
# Cookbook Name:: compute-node
# Recipe:: default
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#
include_recipe "compute-node::mfs"

bash "delete" do
	code <<-DELETE
	if [ -f /etc/nova/nova.conf ]; then mv /etc/nova/nova.conf /etc/nova/nova.old.conf; fi
	if [ -f /etc/nova/nova-compute.conf ]; then rm /etc/nova/nova-compute.conf; fi
	if [ -f /etc/nova/api-paste.ini ]; then rm /etc/nova/api-paste.ini; fi
	DELETE
end

package "nova-compute" do
	action :install
end

#package "nova-network" do
#	action :install
#end

#package "nova-api-metadata" do
#	not_if("ls /etc/init.d | grep nova-api")
#	action :install
#end

template "/etc/nova/nova-compute.conf" do
	source "nova-compute.conf.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

template "/etc/nova/api-paste.ini" do
	source "api-paste.ini.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

template "/etc/nova/nova.conf" do
	source "nova.conf.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

bash "recover" do
	code <<-RECOVER
	if [ -f /etc/nova/nova.old.conf ]; then mv /etc/nova/nova.old.conf /etc/nova/nova.conf; fi
	RECOVER
end

template "/etc/libvirt/qemu.conf" do
	source "qemu.conf.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

template "/etc/libvirt/libvirtd.conf" do
	source "libvirtd.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

template "/etc/init/libvirt-bin.conf" do
	source "libvirt-bin.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

template "/etc/default/libvirt-bin" do
	source "libvirt-bin.erb"
	owner "root"
	group "root"
	mode "0644"
end

bash "mount" do
	not_if("grep mfsmaster /etc/fstab")
	code <<-MOUNT
		echo "mfsmount 	/var/lib/nova/instances fuse mfsmaster=mfsmaster,_netdev 0 0" >> /etc/fstab
		mount -a
		chown nova:nova /var/lib/nova/instances -R
		chmod 755 /var/lib/nova/instances -R
	MOUNT
end

service "libvirt-bin" do
	action :restart
	supports :status => true, :restart => true, :start => true 
end

#service "nova-network" do
#	action :restart
#end

service "nova-compute" do
	action :restart
	supports :status => true, :restart => true, :start => true 
end

include_recipe "compute-node::ntp"
include_recipe "compute-node::munin"



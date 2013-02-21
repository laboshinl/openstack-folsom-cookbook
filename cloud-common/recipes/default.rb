#
# Cookbook Name:: cloud-common
# Recipe:: default
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
# 
#include_recipe "cloud-common::interfaces"
bash "create users" do
	not_if("id nova | grep libvirtd")
	code <<-START
	groupadd -g 999 nova
	groupadd -g 997 libvirtd
	useradd -u 998 -g 999 nova
	gpasswd -a nova libvirtd
	START
end

package "lvm2" do
	action :install 
end

package "xfsprogs" do
	action :install
end

directory "/srv/" do
	owner "root"
	group "root"
	mode 0755
	recursive true
end

directory "/var/lib/mfschunk" do
	owner "root"
	group "root"
	mode 0755
	recursive true
end

#get name of the largest lvm
node.set[:controller][:vg_name]=%x[vgs --sort -size --rows | grep VG -m 1 | awk '{print $2}'][0..-2]

bash "lvcreate" do
	not_if("lvdisplay | grep instances")
	code <<-CREATE
		unit=$(vgdisplay #{node[:controller][:vg_name]} | grep Free |  awk '{print $8}')
		size=$(vgdisplay #{node[:controller][:vg_name]} | grep Free |  awk '{print $7}')
		instances=$(echo "$size*0.4" | bc)
		lvcreate -n instances -L 0$instances$unit #{node[:controller][:vg_name]}
		swift=$(echo "$size*0.1" | bc)
		lvcreate -n swift -L 0$swift$unit #{node[:controller][:vg_name]}
		mkfs.xfs  /dev/#{node[:controller][:vg_name]}/swift
		mkfs.ext4 /dev/#{node[:controller][:vg_name]}/instances
	CREATE
end

if (node[:moosefs][:enabled] == "true") then
	bash "mount" do
		not_if("grep swift /etc/fstab")
		code <<-MOUNT
			echo "/dev/#{node[:controller][:vg_name]}/swift /srv xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0" >> /etc/fstab
			echo "/dev/#{node[:controller][:vg_name]}/instances /var/lib/mfschunk ext4 rw,user,exec 0 0" >> /etc/fstab
			mount -a
		MOUNT
	end

else 
	bash "mount" do
		not_if("grep swift /etc/fstab")
		code <<-MOUNT
			echo "/dev/#{node[:controller][:vg_name]}/swift /srv xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0" >> /etc/fstab
			mount -a
		MOUNT
	end	
end


include_recipe "cloud-common::ip_forwarding"
include_recipe "cloud-common::folsom-repo"
include_recipe "cloud-common::openvswitch"
include_recipe "cloud-common::python-mysql"
if (node[:moosefs][:enabled] == "true") then
	include_recipe "cloud-common::mfs"
end

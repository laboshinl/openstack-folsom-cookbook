#
# Cookbook Name:: cloud-contoller
# Recipe:: lvm
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#
package "xfsprogs" do
	action :install
end

#directory "/mnt/swift_backend" do
#	owner "root"
#	group "root"
#	mode 0755
#	recursive true
#end

bash "lvcreate" do
	code <<-CREATE
		unit=$(vgdisplay #{node[:controller][:vg_name]} | grep Free |  awk '{print $8}')
		size=$(vgdisplay #{node[:controller][:vg_name]} | grep Free |  awk '{print $7}')
		images=$(echo "$size*0.2" | bc)
		lvcreate -n images -L 0$images$unit #{node[:controller][:vg_name]}
		instances=$(echo "$size*0.4" | bc)
		lvcreate -n instances -L 0$instances$unit #{node[:controller][:vg_name]}
		swift=$(echo "$size*0.15" | bc)
		mkfs.ext4 /dev/#{node[:controller][:vg_name]}/instances
		mkfs.ext4 /dev/#{node[:controller][:vg_name]}/images
		mount /dev/#{node[:controller][:vg_name]}/images /mnt
		cp /var/lib/glance/* /mnt -R
		umount /mnt
		mount /dev/#{node[:controller][:vg_name]}/instances /mnt
		cp /var/lib/nova/instances/* /mnt -R
		umount /mnt
	CREATE
end
#echo "/dev/#{node[:controller][:vg_name]}/swift /mnt/swift_backend xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0" >> /etc/fstab
bash "mount" do
	code <<-MOUNT
		echo "/dev/#{node[:controller][:vg_name]}/instances /var/lib/nova/instances ext4 rw,user,exec 0 0" >> /etc/fstab
        	echo "/dev/#{node[:controller][:vg_name]}/images /var/lib/glance ext4 rw,user,exec 0 0" >> /etc/fstab
		mount -a
		chown glance:glance /var/lib/glance -R
		chmod 755 /var/lib/glance -R
		chown nova:nova /var/lib/nova/instances -R
		chmod 755 /var/lib/nova/instances -R
	MOUNT
end

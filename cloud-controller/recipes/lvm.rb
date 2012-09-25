#
# Cookbook Name:: cloud-contoller
# Recipe:: lvm
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

bash "lvcreate" do
	code <<-CREATE
		unit=$(vgdisplay #{node[:controller][:vg_name]} | grep Free |  awk '{print $8}')
		size=$(vgdisplay #{node[:controller][:vg_name]} | grep Free |  awk '{print $7}')
		images=$(echo "$size*0.25" | bc)
		instances=$(echo "$size*0.5" | bc)
		lvcreate -n instances -L $instances$unit #{node[:controller][:vg_name]}
		lvcreate -n images -L $images$unit #{node[:controller][:vg_name]}
		mkfs.ext4 /dev/#{node[:controller][:vg_name]}/instances
		mkfs.ext4 /dev/#{node[:controller][:vg_name]}/images
		mount /dev/#{node[:controller][:vg_name]}/images /mnt
		cp /var/lib/glance/* /mnt -R
		umount /mnt
		mount /dev/#{node[:controller][:vg_name]}/instances /mnt
		cp /var/lib/nova/instances/* /mnt -R
		umount /mnt
		mount /dev/#{node[:controller][:vg_name]}/images /mnt 
	CREATE
end

bash "mount" do
	code <<-MOUNT
		echo "/dev/#{node[:controller][:vg_name]}/instances /var/lib/nova/instances ext4 rw,user,exec 0 0" >> /etc/fstab
		mount /dev/#{node[:controller][:vg_name]}/instances /var/lib/nova/instances
        	echo "/dev/#{node[:controller][:vg_name]}/images /var/lib/glance ext4 rw,user,exec 0 0" >> /etc/fstab
		mount /dev/#{node[:controller][:vg_name]}/images /var/lib/glance
		chown glance:glance /var/lib/glance -R
		chmod 755 /var/lib/glane -R
		chown nova:nova /var/lib/nova/instances -R
		chmod 755 /var/lib/nova/instances -R
	MOUNT
end

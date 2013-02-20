#
# Cookbook Name:: cloud-contoller
# Recipe:: lvm
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#
bash "lvcreate" do
	not_if("lvdisplay | grep images")
	code <<-CREATE
		unit=$(vgdisplay #{node[:controller][:vg_name]} | grep Free |  awk '{print $8}')
		size=$(vgdisplay #{node[:controller][:vg_name]} | grep Free |  awk '{print $7}')
		images=$(echo "$size*0.5" | bc)
		lvcreate -n images -L 0$images$unit #{node[:controller][:vg_name]}
		mkfs.ext4 /dev/#{node[:controller][:vg_name]}/images
	CREATE
end


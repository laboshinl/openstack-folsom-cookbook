#
# Cookbook Name:: cloud-controller
# Recipe:: default
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#
#node.set[:controller][:private_interface]=%x[ip a | grep #{node[:controller][:private_ip]} | grep inet | awk '{print $NF}'][0..-2]
#node.set[:controller][:public_interface]=%x[ip a | grep #{node[:controller][:public_ip]} | grep inet | awk '{print $NF}'][0..-2]
#include_recipe "cloud-controller::ntp"
if (node[:moosefs][:enabled] == "true") then
	include_recipe "cloud-controller::mfs"  
end
include_recipe "cloud-controller::mysql"    
include_recipe "cloud-controller::rabbitmq" 
include_recipe "cloud-controller::keystone" 
include_recipe "cloud-controller::lvm"
include_recipe "cloud-controller::glance"   
include_recipe "cloud-controller::nova"     
include_recipe "cloud-controller::dashboard"
include_recipe "cloud-controller::cinder" 
include_recipe "cloud-controller::swift"
include_recipe "cloud-controller::munin"    
include_recipe "cloud-controller::mydns"

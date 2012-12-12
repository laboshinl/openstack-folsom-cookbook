#
# Cookbook Name:: cloud-controller
# Recipe:: default
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#
include_recipe "cloud-controller::ntp"
include_recipe "cloud-controller::nfs"      
include_recipe "cloud-controller::mysql"    
include_recipe "cloud-controller::rabbitmq" 
include_recipe "cloud-controller::keystone" 
include_recipe "cloud-controller::glance"   
include_recipe "cloud-controller::nova"     
include_recipe "cloud-controller::dashboard"
include_recipe "cloud-controller::lvm"
#include_recipe "cloud-controller::quantum"
include_recipe "cloud-controller::cinder" 
include_recipe "cloud-controller::swift"
include_recipe "cloud-controller::munin"    
include_recipe "cloud-controller::mydns"

#
# Cookbook Name:: cloud-controller
# Recipe:: default
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#
#include_recipe "cloud-common::default"
include_recipe "cloud-controller::mysql"    #done
include_recipe "cloud-controller::keystone" #done
include_recipe "cloud-controller::glance"   #done
include_recipe "cloud-controller::rabbitmq" #done
include_recipe "cloud-controller::nova" 
include_recipe "cloud-controller::novnc"    #done
include_recipe "cloud-controller::dashboard"#done


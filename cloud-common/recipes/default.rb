#
# Cookbook Name:: cloud-common
# Recipe:: default
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
# 

include_recipe "cloud-common::openvswitch"
include_recipe "cloud-common::python-mysql"

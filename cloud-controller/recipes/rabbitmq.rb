#
# Cookbook Name:: cloud-controller
# Recipe:: rabbitmq
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#
#bash "dpkg" do
#	code <<-DPKG
#	dpkg --configure -a
#	DPKG
#end

package "rabbitmq-server" do
	action :install
end

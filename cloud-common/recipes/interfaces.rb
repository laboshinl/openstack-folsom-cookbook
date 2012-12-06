#
# Cookbook Name:: cloud-common
# Recipe:: interfaces
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
# 

bash "edit_interfaces" do
	not_if("grep br-ex /etc/network/interfaces")
	code <<-REPLACE
	sed -i 's/#{node[:controller][:public_interface]}/br-ex/g' /etc/network/interfaces
	sed -i 's/#{node[:controller][:private_interface]}/br-#{node[:controller][:private_interface]}/g' /etc/network/interfaces
	REPLACE
end

bash "append" do
	not_if("grep br-ex /etc/network/interfaces")
	code <<-APPEND
cat >> /etc/network/interfaces << EOF
auto #{node[:controller][:public_interface]}
iface #{node[:controller][:public_interface]} inet manual
        up ifconfig \$IFACE 0.0.0.0 up
        up ip link set \$IFACE promisc on
        down ip link set \$IFACE promisc off
        down ifconfig \$IFACE down

auto #{node[:controller][:private_interface]}
iface #{node[:controller][:private_interface]} inet manual
        up ifconfig \$IFACE 0.0.0.0 up
        up ip link set \$IFACE promisc on
        down ip link set \$IFACE promisc off
        down ifconfig \$IFACE down
EOF
APPEND
end

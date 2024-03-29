#
# Cookbook Name:: cloud-contoller
# Recipe:: mysql
#
# Copyright 2012, RTC
#
# All rights reserved - Do Not Redistribute
#

directory "/var/cache/local/preseeding/" do
	owner "root"
	group "root"
	mode 0755
	recursive true
end

execute "preseed mysql" do
	command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
	action :nothing
end

template "/var/cache/local/preseeding/mysql-server.seed" do
	source "mysql/mysql-server.seed.erb"
	owner "root"
	group "root"
	mode "0600"
	notifies :run, resources(:execute => "preseed mysql"), :immediately
end

package "mysql-server-5.5" do
	action :install
end

package "mysql-server" do
	action :install
end

service "mysql" do
	action :nothing
	supports :status => true, :restart => true, :start => true  
end

template "/etc/mysql/my.cnf" do
	source "mysql/my.cnf.erb"
	owner "root"
	group "root"
	mode "0600"
	notifies :restart, resources(:service => "mysql"), :immediately
end

bash "create_nova" do
	not_if("mysql -uroot -p#{node[:mysql][:password]} -e 'SHOW DATABASES' | grep nova")
		code <<-NOVA
			mysql -uroot -p#{node[:mysql][:password]} -e "CREATE DATABASE nova;"
		NOVA
end

bash "create_cinder" do
	not_if("mysql -uroot -p#{node[:mysql][:password]} -e 'SHOW DATABASES' | grep cinder")
		code <<-CINDER
			mysql -uroot -p#{node[:mysql][:password]} -e "CREATE DATABASE cinder;"
		CINDER
end

bash "create_quantum" do
	not_if("mysql -uroot -p#{node[:mysql][:password]} -e 'SHOW DATABASES' | grep quantum")
		code <<-QUANTUM
			mysql -uroot -p#{node[:mysql][:password]} -e "CREATE DATABASE quantum;"
		QUANTUM
end

bash "create_swift" do
	not_if("mysql -uroot -p#{node[:mysql][:password]} -e 'SHOW DATABASES' | grep swift")
		code <<-SWIFT
			mysql -uroot -p#{node[:mysql][:password]} -e "CREATE DATABASE swift;"
		SWIFT
end

bash "create_glance" do
	not_if("mysql -uroot -p#{node[:mysql][:password]} -e 'SHOW DATABASES' | grep glance")
		code <<-GLANCE
			mysql -uroot -p#{node[:mysql][:password]} -e "CREATE DATABASE glance;"
		GLANCE
end

bash "create_keystone" do
	not_if("mysql -uroot -p#{node[:mysql][:password]} -e 'SHOW DATABASES' | grep keystone")
		code <<-KEYSTONE
			mysql -uroot -p#{node[:mysql][:password]} -e "CREATE DATABASE keystone;"
		KEYSTONE
end

bash "allow" do
	code <<-EOF
		mysql -uroot -p#{node[:mysql][:password]} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '#{node[:mysql][:password]}';"
	EOF
end



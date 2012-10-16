package "munin" do
	action :install
end
package "expect" do 
	action :install 
end
template "/etc/munin/apache.conf" do
	source "/etc/munin/apache.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

template "/etc/munin/munin.conf" do
	source "munin/munin.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

bash "password" do
	code <<-EOF
expect -c "spawn htpasswd -c /etc/munin/munin-htpasswd admin; expect -nocase \"New password:\" {send \"#{node[:keystone][:password]}\r\"}; expect -nocase \"Re-type new password:\" {send \"#{node[:keystone][:password]}\r\"; interact}"
	EOF
end

service "apache2" do 
	action :restart
end

service "munin-node" do 
	action :restart
end


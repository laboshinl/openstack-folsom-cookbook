["mfs-master", "mfs-cgi"].each do |pkg|
	package pkg do
		action :install
	end
end

node.set[:controller][:private_netmask]=%x[ip a | grep #{node[:controller][:private_ip]} | grep inet | awk '{print $2}'][0..-2]

bash "enable" do
	code <<-START
	sed -i "s/false/true/g" /etc/default/mfs-master
	START
end

template "/etc/mfsmaster.cfg" do
	source "mfs/mfsmaster.cfg"
	owner "root"
	group "root"
	mode "0755"
end

template "/etc/mfsexports.cfg" do
	source "mfs/mfsexports.cfg.erb"
	owner "root"
	group "root"
	mode "0755"
end

service "mfs-master" do
		action :restart
end

bash "enable mfs monitoring" do
	code <<-START
	/usr/sbin/mfscgiserv start
	START
end


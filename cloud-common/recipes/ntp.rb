package "ntp" do
	action :install
end

bash "ip_forvarding" do
	code <<-EOF
	sysctl -w net.ipv4.ip_forward=1
	EOF
end

template "/etc/ntp.conf" do
	source "ntp.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end
service "ntp" do
	action :restart
end



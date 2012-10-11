package "ntp" do
	action :install
end

bash "ip_forvarding" do
	code <<-EOF
	sed -i -r 's/^\s*#(net\.ipv4\.ip_forward=1.*)/\1/' /etc/sysctl.conf
	echo 1 > /proc/sys/net/ipv4/ip_forward
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



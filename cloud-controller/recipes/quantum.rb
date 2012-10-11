["quantum-server", "python-cliff", "quantum-plugin-openvswitch-agent", "quantum-l3-agent", "quantum-dhcp-agent", "python-pyparsing"].each do |pkg|
	package pkg do
		action :install
	end
end

template "/etc/quantum/quantum.conf" do
	source "quantum/quantum.conf.erb"
	owner "quantum"
	group "quantum"
	mode "0644"
end

template "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini" do
	source "quantum/ovs_quantum_plugin.ini.erb"
	owner "quantum"
	group "quantum"
	mode "0644"
end

template "/etc/quantum/l3_agent.ini" do
	source "quantum/l3_agent.ini.erb"
	owner "quantum"
	group "quantum"
	mode "0644"
end

template "/etc/quantum/dhcp_agent.ini" do
	source "quantum/dhcp_agent.ini.erb"
	owner "quantum"
	group "quantum"
	mode "0644"
end

template "/etc/quantum/api-paste.ini" do
	source "quantum/api-paste.ini.erb"
	owner "quantum"
	group "quantum"
	mode "0644"
end

["quantum-server", "quantum-plugin-openvswitch-agent", "quantum-dhcp-agent", "quantum-l3-agent"].each do |srv|
	service srv do
		action :restart
	end
end

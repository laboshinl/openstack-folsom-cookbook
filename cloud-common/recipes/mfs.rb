bash "edit hosts file" do
	not_if("grep mfsmaster /etc/hosts")
	code <<-EOF
	echo "#{node[:controller][:private_ip]} mfsmaster" >> /etc/hosts
	EOF
end


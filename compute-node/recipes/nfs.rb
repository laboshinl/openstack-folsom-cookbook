bash "nfs_mount" do
	not_if("ifconfig | grep #{node[:controller][:private_ip]}")	
	code <<-ADD
	echo "#{node[:controller][:private_ip]}:/var/lib/nova/instances /var/lib/nova/instances nfs 		rw,user,exec,nfsvers=3 0 0" >> /etc/fstab
	mount #{node[:controller][:private_ip]}:/var/lib/nova/instances /var/lib/nova/instances
	chmod 777 /var/lib/nova/instances -R
	ADD
end


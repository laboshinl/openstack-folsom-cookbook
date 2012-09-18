bash "nfs_mount" do
  code <<-ADD
  echo "#{node[:controller][:private_ip]}:/var/exports/nova /var/lib/nova/instances nfs rw,user,exec,nfsvers=3 0 0" >> /etc/fstab
  mount #{node[:controller][:private_ip]}:/var/exports/nova /var/lib/nova/instances
  ADD
end


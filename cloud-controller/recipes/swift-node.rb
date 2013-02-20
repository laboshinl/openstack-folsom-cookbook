["swift-account", "swift-container", "swift-object", "rsync"].each do |pkg|
	package pkg do
		action :install
	end
end

directory "/run/swift/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
end
	

%w{node1 node2 node3 node4}.each do |dir|
   directory "/srv/#{dir}/device/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
   end
end

%w{account-server container-server object-server}.each do |dir|
   directory "/etc/swift/#{dir}/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
   end
end

template "/etc/rsyncd.conf" do
	source "swift/rsyncd.conf.erb"
	owner "root"
	group "root"
	mode "0755"
end


%w{1 2 3 4}.each do |num|
template "/etc/swift/container-server/#{num}.conf" do
	source "swift/container.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
	variables :num => "#{num}" 
	end

template "/etc/swift/object-server/#{num}.conf" do
	source "swift/object.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
	variables ({
   		:num => "#{num}" 
  	})
	end
template "/etc/swift/account-server/#{num}.conf" do
	source "swift/account.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
	variables ({
   		:num => "#{num}" 
  	})
	end
end
%x[sed -e "s/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g" -i /etc/default/rsync]

service "rsync" do
	action :restart
end
 
bash "swift" do
	code <<-EOF
	swift-init main start
	EOF
end


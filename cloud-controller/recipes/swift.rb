["swift", "swift-proxy", "swift-account", "swift-container", "swift-object", "xfsprogs", "python-pastedeploy", "rsync"].each do |pkg|
	package pkg do
		action :install
	end
end

directory "/srv/" do
	mode "0755"
	owner "swift"
	group "swift"
	action :create
end

directory "/run/swift/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
end
	

%w{node1 node2 node3 node4}.each do |dir|
   directory "/mnt/swift-backend/#{dir}/device/" do
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

template "/etc/swift/proxy-server.conf" do
	source "swift/proxy-server.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
end

template "/etc/swift/swift.conf" do
	source "swift/swift.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
end

template "/etc/rsyncd.conf" do
	source "swift/rsyncd.conf.erb"
	owner "root"
	group "root"
	mode "0755"
end

template "/etc/swift/account-server/1.conf" do
	source "swift/account.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
end

template "/etc/swift/container-server/1.conf" do
	source "swift/container.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
end

template "/etc/swift/object-server/1.conf" do
	source "swift/object.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
end

bash "swift" do
	not_if("ls /etc/swift| object.ring.gz")
	code <<-EOF
	for i in {1..4}; do sudo ln -s /mnt/swift_backend/node$i /srv/node$i; done;
	sed -e "s/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g" -i /etc/default/rsync
	service rsync restart
	cp /etc/swift/account-server/1.conf /etc/swift/account-server/2.conf
	cp /etc/swift/account-server/1.conf /etc/swift/account-server/3.conf
	cp /etc/swift/account-server/1.conf /etc/swift/account-server/4.conf
	sed -e "s/6012/6022/g;s/LOCAL2/LOCAL3/g;s/node1/node2/g" -i /etc/swift/account-server/2.conf
	sed -e "s/6012/6032/g;s/LOCAL2/LOCAL4/g;s/node1/node3/g" -i /etc/swift/account-server/3.conf
	sed -e "s/6012/6042/g;s/LOCAL2/LOCAL5/g;s/node1/node4/g" -i /etc/swift/account-server/4.conf
	cp /etc/swift/container-server/1.conf /etc/swift/container-server/2.conf
	cp /etc/swift/container-server/1.conf /etc/swift/container-server/3.conf
	cp /etc/swift/container-server/1.conf /etc/swift/container-server/4.conf
	sed -e "s/6011/6021/g;s/LOCAL2/LOCAL3/g;" -i /etc/swift/container-server/2.conf
	sed -e "s/6011/6031/g;s/LOCAL2/LOCAL4/g;" -i /etc/swift/container-server/3.conf
	sed -e "s/6011/6041/g;s/LOCAL2/LOCAL5/g;" -i /etc/swift/container-server/4.conf
	cp /etc/swift/object-server/1.conf /etc/swift/object-server/2.conf
	cp /etc/swift/object-server/1.conf /etc/swift/object-server/3.conf
	cp /etc/swift/object-server/1.conf /etc/swift/object-server/4.conf
	sed -e "s/6010/6020/g;s/LOCAL2/LOCAL3/g;" -i /etc/swift/object-server/2.conf
	sed -e "s/6010/6030/g;s/LOCAL2/LOCAL4/g;" -i /etc/swift/object-server/3.conf
	sed -e "s/6010/6040/g;s/LOCAL2/LOCAL5/g;" -i /etc/swift/object-server/4.conf
	cd /etc/swift
        swift-ring-builder object.builder create 18 3 1
	swift-ring-builder container.builder create 18 3 1
	swift-ring-builder account.builder create 18 3 1
	swift-ring-builder object.builder add z1-127.0.0.1:6010/device 1
	swift-ring-builder object.builder add z2-127.0.0.1:6020/device 1
	swift-ring-builder object.builder add z3-127.0.0.1:6030/device 1
	swift-ring-builder object.builder add z4-127.0.0.1:6040/device 1
	swift-ring-builder object.builder rebalance
	swift-ring-builder container.builder add z1-127.0.0.1:6011/device 1
	swift-ring-builder container.builder add z2-127.0.0.1:6021/device 1
	swift-ring-builder container.builder add z3-127.0.0.1:6031/device 1
	swift-ring-builder container.builder add z4-127.0.0.1:6041/device 1
	swift-ring-builder container.builder rebalance
	swift-ring-builder account.builder add z1-127.0.0.1:6012/device 1
	swift-ring-builder account.builder add z2-127.0.0.1:6022/device 1
	swift-ring-builder account.builder add z3-127.0.0.1:6032/device 1
	swift-ring-builder account.builder add z4-127.0.0.1:6042/device 1
	swift-ring-builder account.builder rebalance
	swift-init main start
	swift-init rest start
	EOF
end

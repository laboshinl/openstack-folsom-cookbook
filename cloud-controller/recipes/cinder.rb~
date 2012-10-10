["cinder-api", "cinder-scheduler", "cinder-volume", "iscsitarget", "open-iscsi", "iscsitarget-dkms", "python-cinderclisent"].each do |pkg|
	package pkg do
		action :install
	end
end

bash "configure" do
	code <<-SED
	sed -i 's/false/true/g' /etc/default/iscsitarget
	SED
end

service "iscsitarget" do
	action :restart
end

service "open-iscsi" do 
	action :restart
end

template "/etc/cinder/cinder.conf" do
	source "cinder.conf.erb"
	owner "cinder"
	group "cinder"
	mode "0644"
end

template "/etc/cinder/api-paste.ini" do
	source "cinder-api-paste.ini.erb"
	owner "cinder"
	group "cinder"
	mode "0644"
end

bash "sync" do
	code <<-SYNC
	cinder-manage db sync
	SYNC
end

["cinder-api", "cinder-scheduler", "cinder-volume"].each do |srv|
	service srv do
		action :restart
	end
end




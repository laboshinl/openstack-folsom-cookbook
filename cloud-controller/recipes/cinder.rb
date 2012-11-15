%w[cinder-api cinder-scheduler cinder-volume iscsitarget open-iscsi iscsitarget-dkms python-cinderclient].each do |pkg|
	package pkg do
		action :install
	end
end

bash "edit" do
	code <<-EOF
	sed -i 's/false/true/g' /etc/default/iscsitarget
	EOF
end

%w[iscsitarget open-iscsi].each do |srv|
	service srv do
		action :restart
	end
end

template "/etc/cinder/cinder.conf" do
	source "cinder/cinder.conf.erb"
	owner "cinder"
	group "cinder"
	mode "0644"
end

template "/etc/cinder/api-paste.ini" do
	source "cinder/api-paste.ini.erb"
	owner "cinder"
	group "cinder"
	mode "0644"
end

bash "sync" do
	code <<-SYNC
	cinder-manage db sync
	SYNC
end

%w[cinder-api cinder-scheduler cinder-volume].each do |srv|
	service srv do
		action :restart
	end
end




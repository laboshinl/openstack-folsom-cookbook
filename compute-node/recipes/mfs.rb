["mfs-chunkserver", "mfs-client", "mfs-metalogger"].each do |pkg|
	package pkg do
		action :install
	end
end

bash "enable mfs server" do
	code <<-START
	chown mfs:mfs /var/lib/mfschunk -R
	sed -i "s/false/true/g" /etc/default/mfs-chunkserver
	sed -i "s/false/true/g" /etc/default/mfs-metalogger
	START
end

template "/etc/mfshdd.cfg" do
	source "mfshdd.cfg"
	owner "root"
	group "root"
	mode "0755"
end

template "/etc/mfsmetalogger.cfg" do
	source "mfsmetalogger.cfg"
	owner "root"
	group "root"
	mode "0755"
end

template "/etc/mfschunkserver.cfg" do
	source "mfschunkserver.cfg"
	owner "root"
	group "root"
	mode "0755"
end

["mfs-chunkserver", "mfs-metalogger"].each do |pkg|
	service pkg do
		action :restart
	end
end



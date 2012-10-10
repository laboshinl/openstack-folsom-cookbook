bash "soa" do
	code <<-EOF
		mysql -uroot -p#{node[:mysql][:password]} nova -e 	"CREATE TABLE IF NOT EXISTS soa (
									id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
									origin     CHAR(255) NOT NULL,
									ns         CHAR(255) NOT NULL,
									mbox       CHAR(255) NOT NULL,
									serial     INT UNSIGNED NOT NULL default '1',
									refresh    INT UNSIGNED NOT NULL default '28800',
									retry      INT UNSIGNED NOT NULL default '7200',
									expire     INT UNSIGNED NOT NULL default '604800',
									minimum    INT UNSIGNED NOT NULL default '86400',
									ttl        INT UNSIGNED NOT NULL default '86400',
									recursive  ENUM('Y', 'N') NOT NULL DEFAULT 'N',
									UNIQUE KEY (origin)
									) Engine=MyISAM;"
	EOF
end

bash "insert_soa" do
	not_if("mysql -uroot -p#{node[:mysql][:password]} nova -e 'SELECT * FROM soa' | grep #{node[:dns][:zone]}")
	code <<-EOF
		mysql -uroot -p#{node[:mysql][:password]} nova -e "INSERT INTO soa(id,origin,ns,mbox) VALUES (1,'#{node[:dns][:zone]}.','ns.#{node[:dns][:zone]}.','mail.#{node[:dns][:zone]}.');"
		mysql -uroot -p#{node[:mysql][:password]} nova -e "INSERT INTO soa(id,origin,ns,mbox) VALUES (2,'public.#{node[:dns][:zone]}.','ns.#{node[:dns][:zone]}.','mail.#{node[:dns][:zone]}.');"
	EOF
end

bash "rr" do
	code <<-EOF
		mysql -uroot -p#{node[:mysql][:password]} nova -e 	"CREATE OR REPLACE VIEW rr AS 
									SELECT instances.id+42000 AS id,1 AS zone, concat(hostname, '-',instances.id) AS name,
									address AS data, 0 AS aux, 300 AS ttl, 'A' AS type
									FROM instances,fixed_ips WHERE instances.id = fixed_ips.instance_id UNION
									SELECT instances.id+69000 AS id,2 AS zone, concat(hostname, '-', instances.id) AS name,
									floating_ips.address AS data, 0 AS aux, 300 AS ttl, 'A' AS type 
									FROM instances,floating_ips,fixed_ips WHERE floating_ips.fixed_ip_id = fixed_ips.id AND instances.id = fixed_ips.instance_id;"
	EOF
end

cookbook_file "/tmp/mydns.deb" do
	source "mydns.deb"
	owner "root"
	group "root"
	mode "0644"
end

dpkg_package "mydns" do
	source "/tmp/mydns.deb"
	action :install
end

template "/etc/mydns.conf" do
	source "mydns.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

service "mydns" do
	action :start
end

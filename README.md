Openstack cookbooks for Ubuntu 12.04
=========

Features
--------
* Configured NFS for live migrations
* Openvswitch integration
* Private network for comunications between nodes

Attributes
---------
```ruby
set[:mysql][:password]="root"  
set[:controller][:private_ip]="10.10.10.10"
set[:controller][:public_ip]="195.208.117.204"
set[:controller][:private_netmask]="8"
set[:keystone][:token]="admin"
set[:keystone][:password]="admin"
set[:keystone][:email]="please@fix.me"
```
Usage
-----

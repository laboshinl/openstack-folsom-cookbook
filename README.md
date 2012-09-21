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
set[:controller][:private_ip]="10.0.0.1"
set[:controller][:public_ip]="8.8.8.8"
set[:controller][:private_netmask]="8"
set[:keystone][:token]="admin"
set[:keystone][:password]="admin"
set[:keystone][:email]="please@fix.me"
```
Usage
-----
```ruby
$ nova-manage floating create 8.8.8.0
$ nova secgroup-add-rule default icmp -1 -1 -s 0.0.0.0/0
$ nova secgroup-add-rule default tcp 22 22 -s 0.0.0.0/0
```


# Is used for installing mysql-server. If it is already installed set your password here.
set[:mysql][:password]="root"

# If there no private network between nodes in your infrastructure you can simply set your public IP in both fields  
set[:controller][:private_ip]="10.10.10.10"
set[:controller][:puplic_ip]="195.208.117.204"

set[:keystone][:token]="admin"
set[:keystone][:password]="admin"
set[:keystone][:email]="please@fix.me"


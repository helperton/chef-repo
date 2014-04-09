include_recipe "openstack-common::expect"

package "mysql-server" do
  action :install
end

template "/etc/my.cnf" do
  source "my.cnf.erb"
end

service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

bash "mysql_install_db" do
	code <<-EOH
	mysql_install_db
	EOH
	not_if { ::Dir.exists?("/var/lib/mysql/mysql") }
end

bash "mysql_secure_installation" do
	code <<-EOF
	/usr/bin/expect -c 'spawn mysql_secure_installation
	expect "Enter current password for root (enter for none):"
	send "\r"
	expect "Set root password?"
	send "y\r"
	expect "New password:"
	send "#{data_bag_item('passwords','openstack_passwords')['MYSQL_ROOT_PASS']}\r"
	expect "Re-enter new password:"
	send "#{data_bag_item('passwords','openstack_passwords')['MYSQL_ROOT_PASS']}\r"
	expect "Remove anonymous users?"
	send "y\r"
	expect "Disallow root login remotely?"
	send "y\r"
	expect "Remove test database and access to it?"
	send "y\r"
	expect "Reload privilege tables now?"
	send "y\r"
	puts "Ended expect script."
	expect eof'
	EOF
	only_if { ::Dir.exists?("/var/lib/mysql/test") }
end

package "openstack-keystone" do
	action :install
end

bash "openstack-config_keystone" do
	code <<-EOF
	/usr/bin/expect -c 'spawn openstack-config --set /etc/keystone/keystone.conf database connection mysql://keystone:#{data_bag_item('passwords','openstack_passwords')['KEYSTONE_DBPASS']}@controller/keystone
	expect "Please enter the password for the 'root' MySQL user:"
  send "#{data_bag_item('passwords','openstack_passwords')['MYSQL_ROOT_PASS']}\r"
	expect eof'
  EOF
	not_if { ::Dir::exists?("/var/lib/mysql/keystone") }
end

bash "openstack-db_keystone" do
	code <<-EOF
	/usr/bin/expect -c 'spawn openstack-db --init --service keystone --password #{data_bag_item('passwords','openstack_passwords')['KEYSTONE_DBPASS']}
	expect "Please enter the password for the 'root' MySQL user:"
  send "#{data_bag_item('passwords','openstack_passwords')['MYSQL_ROOT_PASS']}\r"
	expect eof'
  EOF
	not_if { ::Dir::exists?("/var/lib/mysql/keystone") }
end

bash "openstack-admin-token_keystone" do
	code <<-EOF
  openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token #{data_bag_item('passwords','openstack_passwords')['KEYSTONE_ADMIN_TOK']}
	EOF
end

#template "/etc/qpidd.conf" do
#	source "qpidd.conf.erb"
#end

#service "qpidd" do
#	  supports :status => true, :restart => true, :reload => true
#		  action [ :enable, :start ]
#end


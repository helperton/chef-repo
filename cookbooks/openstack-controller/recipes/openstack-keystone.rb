package "openstack-keystone" do
	action :install
end

bash "openstack-config_keystone" do
	code <<-EOF
	/usr/bin/expect -c 'spawn openstack-config --set /etc/keystone/keystone.conf database connection mysql://keystone:#{data_bag_item('openstack','openstack_passwords')['KEYSTONE_DBPASS']}@controller/keystone
	expect "Please enter the password for the 'root' MySQL user:"
  send "#{data_bag_item('openstack','openstack_passwords')['MYSQL_ROOT_PASS']}\r"
	expect eof'
  EOF
	not_if { ::Dir::exists?("/var/lib/mysql/keystone") }
end

bash "openstack-db_keystone" do
	code <<-EOF
	/usr/bin/expect -c 'spawn openstack-db --init --service keystone --password #{data_bag_item('openstack','openstack_passwords')['KEYSTONE_DBPASS']}
	expect "Please enter the password for the 'root' MySQL user:"
  send "#{data_bag_item('openstack','openstack_passwords')['MYSQL_ROOT_PASS']}\r"
	expect eof'
  EOF
	not_if { ::Dir::exists?("/var/lib/mysql/keystone") }
end

bash "openstack-admin-token_keystone" do
	code <<-EOF
  openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token #{data_bag_item('openstack','openstack_passwords')['KEYSTONE_ADMIN_TOK']}
	EOF
end

bash "openstack-pki-certs_keystone" do
	code <<-EOF
	keystone-manage pki_setup --keystone-user keystone --keystone-group keystone
	EOF
	not_if { ::File.exists?("/etc/keystone/ssl/private/signing_key.pem") }
end

bash "openstack-chown_keystone" do
	code <<-EOF
	chown -R keystone:keystone /etc/keystone/* /var/log/keystone/keystone*.log
	EOF
end

service "openstack-keystone" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Consider this in production to prune expired tokens
#bash "openstack-token-cron_keystone" do
#	code <<-EOF
#	(crontab -l 2>&1 | grep -q token_flush) || \
#	echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' >> /var/spool/cron/root
#	EOF
#end


#template "/etc/qpidd.conf" do
#	source "qpidd.conf.erb"
#end



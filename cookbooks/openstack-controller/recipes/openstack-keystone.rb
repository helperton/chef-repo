$passwords = data_bag_item("openstack","openstack_service_passwords")
$endpoints = data_bag_item("openstack","openstack_service_endpoints")
$users = data_bag_item("openstack","openstack_users")

package "openstack-keystone" do
	action :install
end

bash "openstack-config_keystone" do
	code <<-EOF
	/usr/bin/expect -c 'spawn openstack-config --set /etc/keystone/keystone.conf database connection mysql://keystone:#{$passwords['keystone']}@#{node.name}/keystone
	expect "Please enter the password for the 'root' MySQL user:"
  send "#{$passwords['mysql_root']}\r"
	expect eof'
  EOF
	not_if { ::Dir::exists?("/var/lib/mysql/keystone") }
end

bash "openstack-db_keystone" do
	code <<-EOF
	/usr/bin/expect -c 'spawn openstack-db --init --service keystone --password #{$passwords['keystone']}
	expect "Please enter the password for the 'root' MySQL user:"
  send "#{$passwords['mysql_root']}\r"
	expect eof'
  EOF
	not_if { ::Dir::exists?("/var/lib/mysql/keystone") }
end

bash "openstack-admin-token_keystone" do
	code <<-EOF
  openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token #{$users['keystone']['admin']['token']}
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
  action [ :enable, :start, :reload ]
end

bash "openstack-create-admin_keystone" do
	code <<-EOF
	keystone #{Helpers.auth} user-create --name="admin" --pass="#{$users['keystone']['admin']['password']}" --email="#{$users['keystone']['admin']['email']}"
	EOF
	not_if { /admin/ =~ `keystone #{Helpers.auth} user-get admin` }
end

bash "openstack-create-admin-role_keystone" do
	code <<-EOF
	keystone #{Helpers.auth} role-create --name=admin
	EOF
	not_if { /admin/ =~ `keystone #{Helpers.auth} role-get admin` }
end

bash "openstack-create-admin-tenant_keystone" do
	code <<-EOF
	keystone #{Helpers.auth} tenant-create --name=admin --description="Admin Tenant"
	EOF
	not_if { /admin/ =~ `keystone #{Helpers.auth} tenant-get admin` }
end

bash "openstack-link-admin-to-tenant-and-roles_keystone" do
	code <<-EOF
	keystone #{Helpers.auth} user-role-add --user=admin --tenant=admin --role=admin
	keystone #{Helpers.auth} user-role-add --user=admin --tenant=admin --role=_member_
	EOF
	not_if { /admin/ =~ `keystone #{Helpers.auth} user-role-list --user admin --tenant admin` and /_member_/ =~ `keystone #{Helpers.auth} user-role-list --user admin --tenant admin` }
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



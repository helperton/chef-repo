package "cobbler" do
	action :install
end

package "cobbler-web" do
	action :install
end

service "cobblerd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

service "httpd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

bash "cobbler-selinux" do
	code <<-EOF
	setsebool -P httpd_can_network_connect_cobbler on
	setsebool -P httpd_serve_cobbler_files on
	setsebool -P cobbler_anon_write on
	setsebool -P cobbler_can_network_connect on
	semanage fcontext -a -t public_content_t "var/lib/tftpboot/.*"
	#cobbler_use_cifs --> off
	#cobbler_use_nfs --> off
	EOF
end

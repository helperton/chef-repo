cookbook_file "/etc/cron.d/chef-client" do
	source "etc/cron.d/chef-client"
	mode 00644
end

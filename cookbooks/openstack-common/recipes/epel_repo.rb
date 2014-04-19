include_recipe "openstack-common::wget"

bash "epel_repo" do
	code <<-EOF
	rpm -ivh http://mirror.pnl.gov/epel/6/i386/epel-release-6-8.noarch.rpm
	EOF
	retries 3
	not_if { ::File.exists?("/etc/yum.repos.d/epel.repo") }
end

include_recipe "openstack-common::wget"

bash "epel_repo" do
	code <<-EOF
  rpm -ivh http://epel.mirror.freedomvoice.com/6/i386/epel-release-6-8.noarch.rpm
	EOF
	not_if { ::File.exists?("/etc/yum.repos.d/epel.repo") }
end

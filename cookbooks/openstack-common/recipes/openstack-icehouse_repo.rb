bash "openstack-icehouse repo" do
	code <<-EOF
	rpm -ivh http://repos.fedorapeople.org/repos/openstack/openstack-icehouse/rdo-release-icehouse-1.noarch.rpm
	EOF
	not_if { ::File.exists?("/etc/yum.repos.d/foreman.repo") }
end

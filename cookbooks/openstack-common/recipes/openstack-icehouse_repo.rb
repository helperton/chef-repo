bash "openstack-icehouse repo" do
	code <<-EOF
	yum -y install http://repos.fedorapeople.org/repos/openstack/openstack-icehouse/rdo-release-icehouse-1.noarch.rpm
	EOF
	not_if { ::File.exists?("/etc/yum.repos.d/foreman.repo") }
end

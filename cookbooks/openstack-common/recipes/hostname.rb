template "/etc/sysconfig/network" do
	source "network.erb"
end

bash "hostname" do
	code <<-EOF
	hostname #{node.name}
	EOF
end

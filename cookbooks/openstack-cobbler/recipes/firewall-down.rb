bash "firewall-down" do
	code <<-EOF
	iptables -F
	EOF
end

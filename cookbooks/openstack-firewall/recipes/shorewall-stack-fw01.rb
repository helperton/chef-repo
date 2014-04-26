template "/etc/shorewall/interfaces" do
	source "interfaces.erb"
end

template "/etc/shorewall/shorewall.conf" do
	source "shorewall.conf.erb"
end

template "/etc/shorewall/zones" do
	source "zones.erb"
end

template "/etc/shorewall/policy" do
	source "policy.erb"
end

service "shorewall" do
	  supports :status => true, :restart => true, :reload => true
		  action [ :enable, :start ]
end

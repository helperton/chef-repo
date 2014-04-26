host = data_bag_item('openstack','openstack_hosts')[node.name]

#puts host.inspect

host.each do |iface,attrs|
  #puts "Key: #{iface} Value: #{attrs}"
	template "/etc/sysconfig/network-scripts/ifcfg-#{iface}" do
		variables({
  	  :device => iface,
		  :bootproto => "none",
  	  :onboot => "yes",
			:ipaddr => attrs['ipaddr'],
  	  :netmask => attrs['netmask'],
		  :gateway => attrs['gateway'],
  	  :mtu => attrs['mtu']
		})
		source "ifcfg-ethx.erb"
	end
end


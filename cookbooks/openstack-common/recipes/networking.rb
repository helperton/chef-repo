host_attrs = data_bag_item('openstack','openstack_hosts')[node.name]

#puts host.inspect

host_attrs.each do |iface,attrs|
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

#ruby_block "reboot" do
#	`reboot` and raise "Rebooting to change IP! Cron should start the next run."
#not_if { /#{attrs['ipaddr']}/ =~ `ifconfig eth0` }
#end

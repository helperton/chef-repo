package "ntp" do
	action :install
end

service "ntpd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

package "qpid-cpp-server" do
	action :install
end

template "/etc/qpidd.conf" do
	source "qpidd.conf.erb"
end

service "qpidd" do
	  supports :status => true, :restart => true, :reload => true
		  action [ :enable, :start ]
end


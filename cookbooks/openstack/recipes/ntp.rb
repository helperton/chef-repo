package "ntp" do
	action :install
end

template "ntp.conf" do
	source "ntp.conf.erb"
end

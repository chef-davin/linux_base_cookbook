#
# Cookbook:: linux_base
# Recipe:: cups
#
# Ensures that CUPS is not running on the system
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Kill the CUPS! Save the Trees!
service 'cups' do
  action [:disable, :stop]
end

execute 'reload systemctl daemons' do
  command 'systemctl daemon-reload'
  action :nothing
end

deb_service_files = ['/lib/systemd/system/cups.service', '/etc/init.d/cups']
deb_service_files.each do |svcfile|
  file svcfile do
    action :delete
    only_if { node['platform'] =~ /(debian|ubuntu)/ }
    notifies :run, 'execute[reload systemctl daemons]', :delayed
  end
end

package 'cups' do
  action :purge
end

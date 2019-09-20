#
# Cookbook:: linux_base
# Recipe:: default
#
# Copyright:: 2019, Chef, All Rights Reserved.

# making sure that installing packages actually works
apt_update 'update all platforms' do
  frequency 86400
  action :periodic
  only_if { node['platform'] =~ /(debian|ubuntu)/ }
end

# getting ntp service running - Chrony is the new hotness, so we're going with that
package 'chrony' do
  action :install
end

service 'chrony' do
  case node['platform']
  when 'redhat', 'centos'
    service_name 'chronyd'
  when 'debian', 'ubuntu'
    service_name 'chrony'
  end
  action [:enable, :start]
end

# setting up the timezone and setting system clock to use UTC.
timezone 'setup EST for timezone with UTC system clock' do
  timezone 'America/New_York'
  action :set
end

execute 'force UTC time if it is not set' do
  command 'timedatectl set-local-rtc 0 --adjust-system-clock'
  action :run
  only_if 'hwclock --debug | grep "Assuming hardware clock is kept in local time"'
end

# As a note, I had a really nice custom resource written to do this
# once upon of time back wiht chef-client 12.
# All my old work has been overwritten...
# This makes me sad, though I'm happy to see the progress that chef has made
# :sadpanda:

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

template '/etc/resolv.conf' do
  source 'resolv.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

include_recipe 'linux_base::webserver'

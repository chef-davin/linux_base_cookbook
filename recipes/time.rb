#
# Cookbook:: linux_base
# Recipe:: time
#
# Setting up Chrony for NTP services, setting timezone,
# and ensuring that hwclock is synced to UTC
#
# Copyright:: 2019, The Authors, All Rights Reserved.

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

# Because the above resource doesn't seem to do what it claims 
#   to do and set the hwclock to UTC I'm forcing the issue
execute 'force UTC time if it is not set' do
  command 'timedatectl set-local-rtc 0 --adjust-system-clock'
  action :run
  only_if 'hwclock --debug | grep "Assuming hardware clock is kept in local time"'
end

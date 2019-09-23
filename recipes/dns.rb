#
# Cookbook:: linux_base
# Recipe:: dns
#
# Having Chef manage DNS resolution on the system
# 
# Copyright:: 2019, The Authors, All Rights Reserved.

#Let Chef Manage DNS
service 'systemd-resolved' do
  action [:disable, :stop]
  only_if { node['platform'] =~ /(debian|ubuntu)/ }
end

link '/etc/resolv.conf' do
  action :delete
  only_if 'test -L /etc/resolv.conf'
end

template '/etc/resolv.conf' do
  source 'resolv.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end
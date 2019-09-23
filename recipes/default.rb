#
# Cookbook:: linux_base
# Recipe:: default
#
# Wrapper recipe to run all recipes in the cookbook without a huge run_list
#   on your node definition or in the Policyfile
#
# Copyright:: 2019, Chef, All Rights Reserved.

# making sure that installing packages actually works on debian/ubuntu
apt_update 'update all platforms' do
  frequency 86400
  action :periodic
  only_if { node['platform'] =~ /(debian|ubuntu)/ }
end

include_recipe 'linux_base::dns'
include_recipe 'linux_base::time'
include_recipe 'linux_base::cups'
include_recipe 'linux_base::webserver'

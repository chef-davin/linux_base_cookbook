#
# Cookbook:: linux_base
# Recipe:: webserver
#
# Stands up Apache 2 server and creates a basic placeholder index.html web page
#
# Copyright:: 2019, Chef, All Rights Reserved.

ssl_dir           = '/opt/apache2/ssl'
ssl_cert_file     = "#{ssl_dir}/server.crt"
ssl_cert_key_file = "#{ssl_dir}/server.key"
app_dir           = '/opt/apache2/sites/ssl_site'
site_name         = 'ssl_site'
index_version     = '1'

apache2_install 'default'

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_module 'deflate'
apache2_module 'headers'
apache2_module 'ssl'

apache2_mod_ssl ''

# Create Certificates
directory '/opt/apache2/ssl' do
  extend    Apache2::Cookbook::Helpers
  owner     lazy { default_apache_user }
  group     lazy { default_apache_group }
  recursive true
end

directory app_dir do
  extend    Apache2::Cookbook::Helpers
  owner     lazy { default_apache_user }
  group     lazy { default_apache_group }
  recursive true
end

generate_style_css "Create Stylesheet for #{site_name}" do
  extend Apache2::Cookbook::Helpers
  file_path "#{app_dir}/style.css"
  config_hash node['sites'][site_name]['style_css']
  owner   lazy { default_apache_user }
  group   lazy { default_apache_group }
  action :create
end

cookbook_file "#{app_dir}/background.jpg" do
  extend Apache2::Cookbook::Helpers
  source 'background.jpg'
  owner   lazy { default_apache_user }
  group   lazy { default_apache_group }
  action :create
end

ENV['TZ'] = 'US/Eastern'

run_time = Time.new.strftime('%c')

template "#{app_dir}/index.html" do
  extend  Apache2::Cookbook::Helpers
  source  'index.html.erb'
  owner   lazy { default_apache_user }
  group   lazy { default_apache_group }
  variables(
    time: run_time,
    header: node['sites']['ssl_site']['header'],
    body: node['sites']['ssl_site']['body']
  )
  action :nothing
end

file "#{app_dir}/versions.txt" do
  content "index.html = #{index_version}"
  extend  Apache2::Cookbook::Helpers
  owner   lazy { default_apache_user }
  group   lazy { default_apache_group }
  notifies :create, "template[#{app_dir}/index.html]", :immediately
end

execute 'create-private-key' do
  command "openssl genrsa > #{ssl_cert_key_file}"
  not_if { File.exist?(ssl_cert_key_file) }
end

execute 'create-certficate' do
  command %(openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout #{ssl_cert_key_file} -out #{ssl_cert_file} <<EOF
US
Washington
Seattle
Chef Software, Inc

127.0.0.1
webmaster@example.com
EOF)
  not_if { File.exist?(ssl_cert_file) }
end

# Create site template with our custom config

template site_name do
  extend Apache2::Cookbook::Helpers
  source 'ssl.conf.erb'
  path "#{apache_dir}/sites-available/#{site_name}.conf"
  variables(
    server_name: '127.0.0.1',
    # server_name: 'example.com',
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    site_name: site_name,
    ssl_cert_file: ssl_cert_file,
    ssl_cert_key_file: ssl_cert_key_file
  )
end

apache2_site site_name

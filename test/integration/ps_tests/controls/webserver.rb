# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/
# Copyright: 2018, Chef

app_dir = '/opt/apache2/sites/ssl_site'

control 'webserver-1.0.0' do
  impact 1.0
  title 'Ensure Apache2 is installed'
  desc 'Validate that Apache2 is installed and the service is running'
  if os.debian?
    describe service('apache2') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end

  if os.redhat?
    describe service('httpd') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end

control 'webserver-1.0.1' do
  impact 0.7
  title 'Apache should be listening on HTTPS'
  desc 'Validate server is listening on port 443'
  describe port(443) do
    it { should be_listening }
  end
end

control 'webserver-1.0.2' do
  impact 0.7
  title 'Validate index.html'
  desc 'Should have lorem ipsum fake text and a timestamp'
  describe file("#{app_dir}/index.html") do
    it { should exist }
    its('content') { should match /last updated on [FMSTW].?.? [ADFJMNOS].?.? [0-9]/ }
    its('content')  { should match /Lorem ipsum dolor sit amet/ }
  end
end

control 'webserver-1.0.3' do
  impact 0.7
  title 'Ensure ancillary files on webserver'
  desc 'Validate that background.jpg and style.css are on webserver root directory'
  %w(background.jpg style.css).each do |file|
    describe file("#{app_dir}/#{file}") do
      it { should exist }
    end
  end
end

control 'webserver-1.0.4' do
  impact 0.7
  title 'Validate timestamp in the index.tml'
  desc 'Timestamp should match modified time of the index.html'
  timecheck_cmd = [
    "#!/bin/bash",
    "export filemtime=$(stat -c %y #{app_dir}/index.html)",
    "export indxmtime=$(date -d \"$filemtime\" | awk -F ':' '{print $1}')",
    "grep \"${indxmtime}\" #{app_dir}/index.html"
  ].join("\n")

  # http://inspec.io/docs/reference/resources/command/
  describe command(timecheck_cmd) do
    its('stdout') { should match /Page Content last updated/ }
    its('exit_status') { should eq 0 }
  end
end

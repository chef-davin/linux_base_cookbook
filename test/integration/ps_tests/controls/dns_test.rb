# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/
# Copyright: 2018, Chef

control 'dns-1.0.0' do
  impact 0.7
  title 'Ensure proper nameservers and options in resolv.conf'
  desc '/etc/resolv.conf should be pointing at Google DNS servers and should have timeout set to 5 seconds'
  describe file('/etc/resolv.conf') do
    it { should exist }
    it { should be_owned_by 'root' }
    its('content') { should match /8.8.8.8/ }
    its('content') { should match /8.8.4.4/ }
    its('content') { should match /timeout:5/ }
  end
end

control 'dns-1.0.1' do
  impact 0.7
  title 'Check that systemd-resolved service is not running'
  desc 'This check only applies to debian'
  if os.debian?
    describe service('systemd-resolved') do
      it { should_not be_enabled }
      it { should_not be_running }
    end
  end
end

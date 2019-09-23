# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/
# Copyright: 2018, Chef

control 'ntp-1.0.0' do
  impact 0.7
  title 'Ensure Chrony is installed'
  desc 'For managing NTP time syncing, ensure Chrony is installed on the system'
  describe package('chrony') do
    it { should be_installed }
  end
end

control 'ntp-1.0.1' do
  impact 0.7
  title 'Check that Chrony service is setup and running'
  desc 'Chrony should be installed, enabled, and running'
  if os.debian?
    describe service('chrony') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
  if os.redhat?
    describe service('chronyd') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end

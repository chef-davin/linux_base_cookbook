unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root') do
    it { should exist }
  end
end

# http://inspec.io/docs/reference/resources/package/
describe package('chrony') do
  it { should be_installed }
end

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

describe service('cups') do
  it { should_not be_installed }
  it { should_not be_enabled }
  it { should_not be_running }
end

describe package('cups') do
  it { should_not be_installed }
end

# http://inspec.io/docs/reference/resources/command/
describe command('/sbin/hwclock --debug') do
  its('stdout') { should match /Assuming hardware clock is kept in UTC time/ }
  its('exit_status') { should eq 0 }
end

describe command('timedatectl status') do
  its('stdout') { should match /America\/New_York/ }
  its('exit_status') { should eq 0 }
end

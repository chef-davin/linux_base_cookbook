# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/
# Copyright: 2018, Chef

control 'time-1.0.0' do
  impact 0.7
  title 'Ensure HW Clock is running in UTC'
  desc 'hwclock --debug should be using UTC'
  describe command('/sbin/hwclock --debug') do
    its('stdout') { should match /Assuming hardware clock is kept in UTC time/ }
    its('exit_status') { should eq 0 }
  end
end

control 'time-1.0.1' do
  impact 0.7
  title 'Ensure Timezone is configured correctly'
  desc 'timedatectl should be using Eastern Timezone'
  describe command('timedatectl status') do
    its('stdout') { should match %r{America/New_York} }
    its('exit_status') { should eq 0 }
  end
end

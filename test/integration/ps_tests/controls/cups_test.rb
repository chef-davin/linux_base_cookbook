# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/
# Copyright: 2018, Chef

control 'cups-1.0.0' do
  impact 0.7
  title 'CUPS should be removed from the system'
  desc 'Stop wasting trees, there\'s no need to print things!'
  describe package('cups') do
    it { should_not be_installed }
  end
end

control 'cups-1.0.1' do
  impact 0.7
  title 'CUPS should be removed from the system and should not be running'
  desc 'Stop wasting trees, there\'s no need to print things!'
  describe service('cups') do
    it { should_not be_installed }
    it { should_not be_enabled }
    it { should_not be_running }
  end
end

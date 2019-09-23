# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/
# Copyright: 2018, Chef

title "PS Test - Linux Base"

# Check for Root User
control "linux-1.0.0" do
  impact 1.0
  title "Ensure root user exists"
  desc "Shouldn't every linux system have a root user?"
  describe user('root') do
    it { should exist }
  end
end

# Check for /tmp directory
control "linux-1.0.1" do                    # A unique ID for this control
  impact 0.7                                # The criticality, if this control fails.
  title "Create /tmp directory"             # A human-readable title
  desc "An optional description..."
  describe file("/tmp") do                  # The actual test
    it { should be_directory }
  end
end

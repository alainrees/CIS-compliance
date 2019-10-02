describe file('/var/www') do
  it { should exist }
  its('owner') { should eq 'www-data' }
  its ('mode') { should cmp '755'}
end

describe port(80) do
  it { should be_listening }
  its('processes') { should include 'apache2' }
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end

describe port(443) do
  it { should be_listening }
  its('processes') { should include 'apache2' }
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end

describe service('apache2') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# Overide by OS
service_name = 'postgresql'
if os[:name] == 'centos' and os[:release].start_with?('6')
  service_name = 'postgresql-9.6'
end

control 'Postgres service' do
  impact 0.5
  title 'should be running and enabled'

  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(5432) do
    it { should be_listening }
  end
end

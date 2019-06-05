# Overide by OS
service_name = 'postgresql'
pg_port = 5432
if os[:name] == 'centos' and os[:release].start_with?('6')
  service_name = 'postgresql-9.6'
elsif os[:family] == 'debian' or os[:name] == 'suse'
  pg_port = 5433
end

control 'Postgres service' do
  impact 0.5
  title 'should be running and enabled'

  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(pg_port) do
    it { should be_listening }
  end
end

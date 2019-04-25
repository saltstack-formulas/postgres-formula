control 'Postgres service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('postgresql') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(5432) do
    it { should be_listening }
  end
end

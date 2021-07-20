# frozen_string_literal: true

control 'Postgres configuration' do
  title 'should include the directory'

  describe file('/srv/my_tablespace') do
    it { should be_directory }
    it { should be_owned_by 'postgres' }
    it { should be_grouped_into 'postgres' }
    its('mode') { should cmp '0700' }
  end
end

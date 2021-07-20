# frozen_string_literal: true

service_name =
  case platform[:family]
  when 'redhat', 'fedora', 'suse'
    case system.platform[:release]
    when 'tumbleweed'
      'postgresql'
    else
      'postgresql-13'
    end
  else
    'postgresql'
  end

pg_port =
  case platform[:family]
  when 'debian', 'suse'
    5433
  else
    5432
  end

control 'Postgres service' do
  impact 0.5
  title 'should be installed, enabled and running'

  describe service(service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe port(pg_port) do
    it { should be_listening }
  end
end

# Overide by Platform
pg_port = '5432'
if platform[:family] == 'debian' or platform[:family] == 'suse'
  pg_port = '5433'
end

control 'Postgres command' do
  title 'should match desired lines'

  # Can't use `%Q` here due to the `\`
  describe command(%q{su - postgres -c 'psql -p} + pg_port + %q{ -qtc "\l+ db2"'}) do
    its(:stdout) { should match(%r{db2.*remoteUser.*UTF8.*en_US.UTF-8.*en_US.UTF-8.*my_space}) }
  end
end

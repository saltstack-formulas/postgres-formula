# frozen_string_literal: true

# Overide by Platform
pg_port = '5432'
pg_port = '5433' if (platform[:family] == 'debian') || (platform[:family] == 'suse')

control 'Postgres command' do
  title 'should match desired lines'

  # Can't use `%Q` here due to the `\`
  describe command("su - postgres -c 'psql -p#{pg_port} -qtc \"\\l+ db2\"'") do
    its(:stdout) do
      should match(
        /db2.*remoteUser.*UTF8.*en_US.UTF-8.*en_US.UTF-8.*my_space/
      )
    end
  end
end

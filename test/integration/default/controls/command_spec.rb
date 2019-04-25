control 'Postgres command' do
  title 'should match desired lines'

  describe command(%q{su - postgres -c 'psql -qtc "\l+ db2"'}) do
    its(:stdout) { should match(/.*db2.*my_space/) }
    # its(:stdout) { should match(/db2.*remoteUser.*UTF8.*en_US\.UTF-8.*en_US\.UTF-8.*my_space/) }
  end
end

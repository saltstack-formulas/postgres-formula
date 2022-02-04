# frozen_string_literal: true

case platform.family
when 'redhat', 'fedora'
  repo_file = '/etc/yum.repos.d/pgdg13.repo'
  os_name_repo_url = {
    'amazon' => 'https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-7-$basearch',
    'fedora' => 'https://download.postgresql.org/pub/repos/yum/13/fedora/fedora-$releasever-$basearch',
    'default' => 'https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-$releasever-$basearch'
  }
  repo_url = os_name_repo_url[platform.name]

when 'debian'
  # Inspec does not provide a `codename` matcher, so we add ours
  finger_codename = {
    'ubuntu-18.04' => 'bionic',
    'ubuntu-20.04' => 'focal',
    'debian-9' => 'stretch',
    'debian-10' => 'buster',
    'debian-11' => 'bullseye'
  }
  codename = finger_codename[system.platform[:finger]]

  repo_keyring = '/usr/share/postgresql-common/pgdg/apt.postgresql.org.gpg'
  repo_file = '/etc/apt/sources.list.d/pgdg.list'
  # rubocop:disable Metrics/LineLength
  repo_url = "deb [signed-by=#{repo_keyring}] http://apt.postgresql.org/pub/repos/apt #{codename}-pgdg main"
  # rubocop:enable Metrics/LineLength
end

control 'Postgresql repository keyring' do
  title 'should be installed'

  only_if('Requirement for Debian family') do
    os.debian?
  end

  describe package('pgdg-keyring') do
    it { should be_installed }
  end

  describe file(repo_keyring) do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
  end
end

control 'Postgresql repository' do
  impact 1
  title 'should be configured'
  describe file(repo_file) do
    its('content') { should include repo_url }
  end
end

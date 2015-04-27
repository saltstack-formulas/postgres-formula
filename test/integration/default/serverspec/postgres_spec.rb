require "serverspec"

describe service("postgres") do
  it { should be_enabled }
  it { should be_running }
end

describe port("5432") do
  it { should be_listening }
end

# frozen_string_literal: true

# https://docs.chef.io/inspec/profiles/#including-all-controls-from-a-profile
# Could use `include_controls` in this scenario
# include_controls 'share'

# https://docs.chef.io/inspec/profiles/#selectively-including-controls-from-a-profile
# However, using `require_controls` for more clarity
require_controls 'share' do
  control 'Postgres command'
  control 'Postgres configuration'
  # control 'Postgres service'
end

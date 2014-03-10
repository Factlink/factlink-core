require 'bundler'
Bundler.setup

require 'goliath/test_helper'
require 'approvals'

Goliath.env = :test

RSpec.configure do |c|
  c.include Goliath::TestHelper
end

if ENV['COVERAGE']
  require_relative 'support/simplecov'
end

require_relative '../lib/opener/kaf_parser'
require_relative 'support/fixture'
require_relative 'support/nodes'

RSpec.configure do |config|
  config.color = true
end

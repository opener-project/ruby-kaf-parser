if ENV['COVERAGE']
  require_relative 'support/simplecov'
end

require_relative '../lib/opener/kaf_parser'
require_relative 'support/fixture'

RSpec.configure do |config|
  config.color = true
end

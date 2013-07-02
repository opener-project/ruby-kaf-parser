require 'simplecov'

SimpleCov.configure do
  root         File.expand_path('../../../', __FILE__)
  command_name 'rspec'
  project_name 'opener-kaf-parser'

  add_filter 'spec'
  add_filter 'lib/opener/kaf_parser/version'
end

SimpleCov.start

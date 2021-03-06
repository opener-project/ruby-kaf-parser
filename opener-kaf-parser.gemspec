require File.expand_path('../lib/opener/kaf_parser/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'opener-kaf-parser'
  gem.version     = Opener::KafParser::VERSION
  gem.authors     = ['Yorick Peterse <yorickpeterse@olery.com>']
  gem.summary     = 'A KAF parser written in Ruby.'
  gem.description = gem.summary
  gem.has_rdoc    = 'yard'

  gem.license = 'Apache 2.0'

  gem.required_ruby_version = '>= 1.9.3'

  gem.files = Dir.glob([
    'doc/**/*',
    'lib/**/*',
    'LICENSE',
    '*.gemspec',
    'README.md',
    'LICENSE.txt'
  ]).select { |file| File.file?(file) }

  gem.add_dependency 'nokogiri'
  gem.add_dependency 'builder'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'redcarpet', ['>= 2.0']
end

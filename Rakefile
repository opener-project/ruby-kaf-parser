require 'bundler/gem_tasks'

Dir[File.expand_path('../task/*.rake', __FILE__)].each do |task|
  import(task)
end

task :default => :test

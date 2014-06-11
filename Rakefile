require "bundler/gem_tasks"

require 'cucumber/rake/task'
require 'rspec/core/rake_task'

task :default => :tests

task :tests => [:spec, :features]

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

RSpec::Core::RakeTask.new(:spec)

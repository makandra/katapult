require "bundler/gem_tasks"

require 'cucumber/rake/task'
require 'rspec/core/rake_task'

task :default => :tests

task :tests => [:spec, :features]

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

RSpec::Core::RakeTask.new(:spec)

task :update_readme do
  require_relative 'lib/katapult/version'
  readme_path = 'README.md'
  readme = File.read readme_path

  # Using \s+ to support line breaks
  readme.sub! /(currently\s+it's\s+Rails\s+)[\d\.]+/, "\\1#{Katapult::RAILS_VERSION}"
  readme.sub! /(and\s+Ruby\s+)[\d\.]+\d/, "\\1#{Katapult::RUBY_VERSION}"
  File.open readme_path, 'w' do |f|
    f.write readme
  end
end

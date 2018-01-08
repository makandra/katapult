# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'katapult/version'

Gem::Specification.new do |spec|
  spec.name          = 'katapult'
  spec.version       = Katapult::VERSION
  spec.authors       = ['Dominik Schöler']
  spec.email         = ['dominik.schoeler@makandra.de']
  spec.summary       = %q{Kickstart Rails development}
  spec.description   = %q{
    Katapult is a framework for generating base code for Rails applications in
    two leaps. Basics Generation prepares a new Rails application with lots of
    best practices, Model Transformation generates application code from a model
    of the application.
  }
  spec.homepage      = 'https://github.com/makandra/katapult'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ['lib']

  # spec.required_ruby_version = Katapult::RUBY_VERSION

  spec.add_runtime_dependency 'rails', Katapult::RAILS_VERSION
  spec.add_runtime_dependency 'spring' # speed-up
end

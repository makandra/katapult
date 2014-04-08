# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wheelie/version'

Gem::Specification.new do |spec|
  spec.name          = 'wheelie'
  spec.version       = Wheelie::VERSION
  spec.authors       = ['Dominik Schöler']
  spec.email         = ['dominik.schoeler@makandra.de']
  spec.summary       = %q{Kickstart Rails app development.}
  spec.description   = %q{Wheelie is a framework for generating base code.}
  spec.homepage      = 'https://github.com/makandra/wheelie'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'aruba'
end

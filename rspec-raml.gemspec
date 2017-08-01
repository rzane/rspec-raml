# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/raml/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec-raml'
  spec.version       = Rspec::Raml::VERSION
  spec.authors       = ['Ray Zane']
  spec.email         = ['raymondzane@gmail.com']

  spec.summary       = %q{RSpec matchers for working with RAML.}
  spec.description   = %q{RSpec matchers for working with RAML.}
  spec.homepage      = 'https://github.com/rzane/rspec-raml'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'raml_ruby'
  spec.add_dependency 'rspec'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'appleslice/version'

Gem::Specification.new do |spec|
  spec.name          = "appleslice"
  spec.version       = AppleSlice::VERSION
  spec.authors       = ["Clay Allsopp"]
  spec.email         = ["clay@usepropeller.com"]
  spec.summary       = %q{Easily parse Apple & iTunes Connect emails}
  spec.homepage      = "https://github.com/usepropeller/appleslice"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", ">= 1.6.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end

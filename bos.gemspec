# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bos/version'

Gem::Specification.new do |spec|
  spec.name          = "bos"
  spec.version       = Bos::VERSION
  spec.authors       = ["Feng Ce"]
  spec.email         = ["kalelfc@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ""
  end

  spec.summary       = "a bos clien"
  spec.description   = "a bos client"
  spec.homepage      = "http://www.edaixi.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "typhoeus", "~> 1.1"
end

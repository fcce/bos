# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bos_client/version'

Gem::Specification.new do |spec|
  spec.name          = "bos_client"
  spec.version       = BosClient::VERSION
  spec.authors       = ["Feng Ce"]
  spec.email         = ["kalelfc@gmail.com"]

  spec.summary       = "Baidu Object Storage Unofficial Ruby SDK"
  spec.description   = "Library for accessing BOS objects and buckets through REST API"
  spec.homepage      = "http://github.com/fcce/bos"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0"

  spec.add_runtime_dependency "typhoeus", "~> 1.1"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.1"
end

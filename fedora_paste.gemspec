# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fedora_paste/version'

Gem::Specification.new do |spec|
  spec.name          = "fedora_paste"
  spec.version       = FedoraPaste::VERSION
  spec.authors       = ["Ivan Arakcheev", "Paul Pavlovsky"]
  spec.email         = ["wildfiler0@gmail.com", "fatpaher@gmail.com"]

  spec.summary       = "CLI tool and library to work with paste.fedoraproject.org"
  spec.homepage      = "https://github.com/wildfiler/fedora_paste"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"

  spec.add_dependency "httparty"
end

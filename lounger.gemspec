# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lounger/version'

Gem::Specification.new do |spec|
  spec.name          = "lounger"
  spec.version       = Lounger::VERSION
  spec.authors       = ["Groza Sergiu"]
  spec.email         = ["serioja90@gmail.com"]
  spec.license       = "MIT"

  spec.summary       = %q{A simple Ruby gem for current thread idling}
  spec.description   = %q{Lounger is a Ruby gem that, as its name suggests, allows to make the current thread doing nothing. }
  spec.homepage      = "https://github.com/serioja90/lounger"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vahana/version'

Gem::Specification.new do |spec|
  spec.name          = "vahana"
  spec.version       = Vahana::VERSION
  spec.authors       = ["Przemysław Janowski"]
  spec.email         = ["przemyslaw.janowski@outlook.com"]

  spec.summary       = "Easily migrate data between Redis and MongoDB."
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency "mongo", "~> 2.0"
  spec.add_dependency "redis", "~> 3.2"
  spec.add_dependency "cassandra-driver", "~> 2.1"
  spec.add_dependency "json", "~> 1.8"
  spec.add_dependency "neo4j-core", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.5"
end

# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "object_identifier/version"

Gem::Specification.new do |spec|
  spec.name          = "object_identifier"
  spec.version       = ObjectIdentifier::VERSION
  spec.authors       = ["Paul Dobbins", "Evan Sherwood"]
  spec.email         = ["paul.dobbins@icloud.com"]
  spec.required_ruby_version = ">= 2.4.0"

  spec.summary       = "ObjectIdentifier identifies an object by its class name and attributes."
  spec.description   = "Object Identifier allows quick, easy, and uniform identification of an object by inspecting its class name and outputting any desirable attributes/methods. It is great for logging, sending descriptive notification messages, etc."
  spec.homepage      = "https://github.com/pdobb/object_identifier"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "reek"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "simplecov"
end

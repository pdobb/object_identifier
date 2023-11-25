# frozen_string_literal: true

require_relative "lib/object_identifier/version"

Gem::Specification.new do |spec|
  spec.name = "object_identifier"
  spec.version = ObjectIdentifier::VERSION
  spec.authors = ["Paul DobbinSchmaltz"]
  spec.email = ["p.dobbinschmaltz@icloud.com"]

  spec.summary = "Object Identifier identifies an object by its class name and attributes."
  spec.description = "Object Identifier allows quick, easy, and uniform identification of an object by inspecting its class name and outputting any desirable attributes/methods. It is great for logging, sending descriptive notification messages, etc."
  spec.homepage = "https://github.com/pdobb/object_identifier"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/pdobb/object_identifier/issues",
    "changelog_uri" => "https://github.com/pdobb/object_identifier/releases",
    "source_code_uri" => "https://github.com/pdobb/object_identifier",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "gemwork"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "much-stub"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "reek"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "solargraph"
end

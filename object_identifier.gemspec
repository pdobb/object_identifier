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
  spec.required_ruby_version = ">= 3.1"

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

  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "gemwork"
  spec.add_development_dependency "rake"
end

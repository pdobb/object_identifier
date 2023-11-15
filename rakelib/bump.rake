# frozen_string_literal: true

require "date"
require "open-uri"
require "yaml"

desc "Update Bundler version, Ruby version, and LICENSE year in relevant files"
task :bump do
  run_tasks(%w[
    bump:bundler
    bump:ruby
    bump:year
  ])
end

namespace :bump do
  desc "Update Bundler version to latest in Gemfile.lock"
  task :bundler do
    version = Gem.latest_version_for("bundler").to_s
    replace_in_file("Gemfile.lock", /^BUNDLED WITH\n\s+(\d\S+)$/ => version)
  end

  desc "Update Ruby version targets in relevant files"
  task :ruby do
    replace_in_file(
      "object_identifier.gemspec",
      /ruby_version = .*">= (.*)"/ => RubyVersions.lowest_supported_minor)
    replace_in_file(
      ".rubocop.yml",
      /TargetRubyVersion: (.*)/ => RubyVersions.lowest_supported_minor)
    replace_in_file(
      ".github/workflows/ci.yml",
      /ruby-version: "([\d.]+)"/ => RubyVersions.latest)
    replace_in_file(
      ".github/workflows/ci.yml",
      /ruby-version: (\[(?:"[\d.]+"(?:, )?)*\])/ =>
        RubyVersions.latest_supported_minors.to_s)
  end

  desc "Update year to current in LICENSE.txt"
  task :year do
    replace_in_file("LICENSE.txt", /\(c\) (\d+)/ => Date.today.year.to_s)
  end
end

def replace_in_file(path, replacements)
  file_contents = File.read(path)
  original_file_contents = file_contents.dup

  replacements.each do |regex, text|
    raise "Can't find #{regex} in #{path}" unless regex.match?(file_contents)

    file_contents.gsub!(regex) do |match|
      match[regex, 1] = text
      match
    end
  end

  File.write(path, file_contents) if file_contents != original_file_contents
end

# RubyVersions extracts current Ruby versions info from
# https://raw.githubusercontent.com/ruby/www.ruby-lang.org/HEAD/_data/downloads.yml
# -- which specifies the Ruby releases that will be listed on
# https://www.ruby-lang.org/en/downloads/
module RubyVersions
  MINOR_VERSION_REGEX = /\d+\.\d+/.freeze
  RUBY_VERSIONS_YAML_PATH =
    "https://raw.githubusercontent.com/ruby/www.ruby-lang.org/HEAD/_data/downloads.yml"
  VERSION_TYPES = %i[
    eol
    security_maintenance
    stable
  ].freeze

  def self.latest
    latest_supported_patches.last
  end

  def self.latest_supported_minors
    latest_supported_patches.map { |version_string|
      version_string[MINOR_VERSION_REGEX]
    }
  end

  def self.latest_supported_patches
    @latest_supported_patches ||= begin
      patches = versions.fetch_values(*VERSION_TYPES).compact.flatten
      patches.map { |patch| Gem::Version.new(patch) }.sort!.map(&:to_s)
    end
  end

  def self.lowest_supported_minor
    latest_supported_patches.first[MINOR_VERSION_REGEX]
  end

  private

  def self.versions
    @versions ||= begin
      raw_yaml = URI.parse(RUBY_VERSIONS_YAML_PATH).open
      YAML.safe_load(raw_yaml, symbolize_names: true)
    end
  end
  private_class_method :versions
end

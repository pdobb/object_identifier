# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/bin/"
  add_filter "/test/"
end
puts "SimpleCov enabled."

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "object_identifier"

require "minitest/autorun"
require "minitest/reporters"
require "pry"

require "much-stub"

Minitest::Test.make_my_diffs_pretty!
reporter_options = { color: true }
Minitest::Reporters.use!(
  Minitest::Reporters::DefaultReporter.new(reporter_options))

def context(...)
  describe(...)
end

class Minitest::Spec
  after do
    MuchStub.unstub!
  end
end

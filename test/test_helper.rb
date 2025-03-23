# frozen_string_literal: true

require "gemwork/test/support/simplecov"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "object_identifier"

require "minitest/autorun"

require "gemwork/test/support/much_stub"
require "gemwork/test/support/reporters"
require "gemwork/test/support/spec_dsl"

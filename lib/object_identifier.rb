# frozen_string_literal: true

# ObjectIdentifier is the base namespace for all modules/classes related to the
# object_identifier gem.
module ObjectIdentifier
  module Formatters
  end
end

require "object_identifier/version"
require "object_identifier/array_wrap"
require "object_identifier/identifier"
require "object_identifier/formatters/string_formatter"
require "core_ext/object"
require "core_ext/string"
require "core_ext/symbol"
require "core_ext/big_decimal"

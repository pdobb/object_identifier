# frozen_string_literal: true

# ObjectIdentifier is the base namespace for all modules/classes related to the
# object_identifier gem.
module ObjectIdentifier
  # ObjectIdentifier::Formatters
  module Formatters
  end

  # ObjectIdentifier::ArrayWrap mirrors the implementation of Rails'
  # {Array.wrap} method. This allows us to get around objects that respond to
  # `to_a` (such as Struct) and, instead, either utilize `to_ary` or just
  # actually wrap the object in an Array ourselves.
  class ArrayWrap
    def self.call(object)
      if object.nil?
        []
      elsif object.respond_to?(:to_ary)
        object.to_ary || [object]
      else
        [object]
      end
    end
  end
end

require "object_identifier/version"
require "object_identifier/identifier"
require "object_identifier/formatters/string_formatter"
require "core_ext/object"
require "core_ext/string"
require "core_ext/symbol"
require "core_ext/big_decimal"

# frozen_string_literal: true

# ObjectIdentifier is the base namespace for all modules/classes related to the
# object_identifier gem.
module ObjectIdentifier
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

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset_configuration
    @configuration = Configuration.new
  end

  # ObjectIdentifier::Configuration stores the default configuration options for
  # the ObjectIdentifier gem. Modification of attributes is possible at any
  # time, and values will persist for the duration of the running process.
  class Configuration
    attr_reader :formatter_class,
                :default_attributes

    def initialize
      @formatter_class = ObjectIdentifier::StringFormatter
      @default_attributes = %i[id]
    end

    def formatter_class=(value)
      unless value.is_a?(Class)
        raise TypeError, "Formatter must be a Class constant"
      end

      @formatter_class = value
    end

    def default_attributes=(value)
      @default_attributes = value.to_a.map!(&:to_sym)
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

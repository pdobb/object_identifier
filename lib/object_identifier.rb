# frozen_string_literal: true

# ObjectIdentifier is the base namespace for all modules/classes related to the
# object_identifier gem.
module ObjectIdentifier
  # ObjectIdentifier.call is the main entry point for use of this gem. In
  # typical usage, however, this method will almost exclusively just be called
  # by {Object#identify}, as defined in lib/core_ext/object.rb.
  # :reek:LongParameterList
  def self.call(
        objects,
        *attributes,
        formatter_class: default_formatter_class,
        **formatter_options)

    parameters =
      ObjectIdentifier::Parameters.build(
        attributes: attributes,
        formatter_options: formatter_options)

    formatter_class.(objects, parameters: parameters)
  end

  # Default Configuration Accessors

  # The default formatter class to use ({ObjectIdentifier::StringFormatter}).
  def self.default_formatter_class
    configuration.formatter_class
  end

  # The default attributes to include on object inspections.
  def self.default_attributes
    configuration.default_attributes
  end

  # Custom Configuration Getters/Setters

  # Accessor for the {ObjectIdentifier::Configuration} object.
  def self.configuration
    @configuration ||= Configuration.new
  end

  # @yieldparam configuration [ObjectIdentifier::Configuration]
  def self.configure
    yield(configuration)
  end

  # Reset the current configuration settings memoized by
  # {ObjectIdentifier.configuration}.
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
require "object_identifier/array_wrap"
require "object_identifier/parameters"
require "object_identifier/formatters/base_formatter"
require "object_identifier/formatters/string_formatter"
require "core_ext/object"
require "core_ext/string"
require "core_ext/symbol"
require "core_ext/big_decimal"

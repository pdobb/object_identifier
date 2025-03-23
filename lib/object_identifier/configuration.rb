# frozen_string_literal: true

# ObjectIdentifier is the top-level namespace/module for this gem.
module ObjectIdentifier
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
    @configuration ||= ObjectIdentifier::Configuration.new
  end

  # @yieldparam configuration [ObjectIdentifier::Configuration]
  def self.configure
    yield(configuration)
  end

  # Reset the current configuration settings memoized by
  # {ObjectIdentifier.configuration}.
  def self.reset_configuration
    @configuration = ObjectIdentifier::Configuration.new
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
        raise(TypeError, "Formatter must be a Class constant")
      end

      @formatter_class = value
    end

    def default_attributes=(value)
      @default_attributes = value.to_a.map!(&:to_sym)
    end
  end
end

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
      buid_parameters(
        attributes: attributes,
        formatter_options: formatter_options)

    formatter_class.(objects, parameters)
  end

  # Factory method for building an {ObjectIdentifier::Parameters} object.
  def self.buid_parameters(attributes: [], formatter_options: {})
    attrs = ObjectIdentifier::ArrayWrap.(attributes)
    attrs = default_attributes if attrs.empty?
    attrs.flatten!

    Parameters.new(
      attributes: attrs,
      formatter_options: formatter_options.to_h)
  end

  def self.default_formatter_class
    configuration.formatter_class
  end

  def self.default_attributes
    configuration.default_attributes
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

  # ObjectIdentifier::Parameters encapsulates the attributes list and
  # formatter options that may be needed for custom formatting during object
  # identification.
  class Parameters
    KLASS_NOT_GIVEN = "NOT_GIVEN"

    attr_reader :attributes

    # @param attributes [Array, *args] a list of method calls to interrogate the
    #   given object(s) with
    # @param formatter_options[:limit] [Integer, nil] (nil) a given limit on the
    #   number of objects to interrogate
    # @param formatter_options[:klass] [#to_s] a preferred type name for
    #   identifying the given object(s) as
    def initialize(
          attributes: [],
          formatter_options: {})
      @attributes = attributes
      @limit = formatter_options.fetch(:limit, nil)
      @klass = formatter_options.fetch(:klass, KLASS_NOT_GIVEN)
    end

    # NOTE: Expects a block if a value wasn't supplied on initialization.
    def limit
      @limit || (yield if block_given?)
    end

    # NOTE: Expects a block if a value wasn't supplied on initialization.
    def klass
      if klass_given?
        @klass.to_s
      elsif block_given?
        yield.to_s
      else
        nil
      end
    end

    private

    def klass_given?
      @klass != KLASS_NOT_GIVEN
    end
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
require "object_identifier/formatters/string_formatter"
require "core_ext/object"
require "core_ext/string"
require "core_ext/symbol"
require "core_ext/big_decimal"

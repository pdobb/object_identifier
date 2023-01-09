# frozen_string_literal: true

# ObjectIdentifier::Identifier manages construction of identification outputs
# using the passed in formatter_class.
class ObjectIdentifier::Identifier
  # NOTE: `kargs` may be specific to the Formatter being called.
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

  def self.buid_parameters(attributes: [], formatter_options: {})
    attrs = ObjectIdentifier::ArrayWrap.(attributes)
    attrs = default_attributes if attrs.empty?
    attrs.flatten!

    Parameters.new(
      attributes: attrs,
      formatter_options: formatter_options.to_h)
  end

  def self.default_formatter_class
    ObjectIdentifier.configuration.formatter_class
  end

  def self.default_attributes
    ObjectIdentifier.configuration.default_attributes
  end

  # ObjectIdentifier::Identifier::Parameters encapsulates the attributes and
  # formatter options relevant to the task of formatting for object
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
      @klass = formatter_options.fetch(:klass, KLASS_NOT_GIVEN).to_s
    end

    # NOTE: Expects a block if a value wasn't supplied on initialization.
    def limit
      @limit || yield
    end

    # NOTE: Expects a block if a value wasn't supplied on initialization.
    def klass
      if klass_given?
        @klass
      elsif block_given?
        yield
      else
        nil
      end
    end

    def klass_given?
      @klass != KLASS_NOT_GIVEN
    end
  end
end

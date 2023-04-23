# frozen_string_literal: true

# ObjectIdentifier::Parameters encapsulates the attributes list and
# formatter options that may be needed for custom formatting during object
# identification.
class ObjectIdentifier::Parameters
  KLASS_NOT_GIVEN = "NOT_GIVEN"

  attr_reader :attributes

  # Factory method for building an {ObjectIdentifier::Parameters} object. Uses
  # ObjectIdentifier.default_attributes if the given `attributes` array is
  # empty.
  def self.build(attributes: [], formatter_options: {})
    attrs = ObjectIdentifier::ArrayWrap.(attributes)
    attrs = ObjectIdentifier.default_attributes if attrs.empty?
    attrs.flatten!

    new(
      attributes: attrs,
      formatter_options: formatter_options.to_h)
  end

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

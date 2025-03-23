# frozen_string_literal: true

# ObjectIdentifier::Parameters encapsulates the attributes list and
# formatter options that may be needed for custom formatting during object
# identification.
class ObjectIdentifier::Parameters
  # This String to display if `formatter_options[:class]` isn't present.
  CLASS_NOT_GIVEN = "NOT_GIVEN"

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

  # @param attributes [Array, *args] A list of method calls to interrogate the
  #   given object(s) with.
  # @option formatter_options[:limit] [Integer, nil] A given limit on the number
  #   of objects to interrogate.
  # @option formatter_options[:class] [#to_s] A preferred type name for
  #   identifying the given object(s) as.
  def initialize( # rubocop:disable Metrics/MethodLength
        attributes: [],
        formatter_options: {})
    @attributes = attributes
    @limit = formatter_options.fetch(:limit, nil)
    @class =
      formatter_options.fetch(:class) {
        # For backwards compatibility with earlier versions of this gem.
        if formatter_options.key?(:klass)
          warn(
            "DEPRECATION WARNING: "\
            "The `klass` option is deprecated and will be removed in v1.0. "\
            "Use `class` instead.")
          formatter_options[:klass]
        else
          CLASS_NOT_GIVEN
        end
      }
  end

  # NOTE: Expects a block if a value wasn't supplied on initialization.
  def limit
    @limit || (yield if block_given?)
  end

  # NOTE: Expects a block if a value wasn't supplied on initialization.
  def class
    if class_given?
      @class.to_s
    elsif block_given?
      yield.to_s
    else
      nil
    end
  end

  private

  def class_given?
    @class != CLASS_NOT_GIVEN
  end
end

# ObjectIdentifier::Formatters::StringFormatter builds a String to identify the
# given object(s).
class ObjectIdentifier::Formatters::StringFormatter
  NO_OBJECTS_INDICATOR = "[no objects]"
  KLASS_NOT_GIVEN = :not_given

  def self.call(objects, *attributes, **kargs)
    new(objects, *attributes, **kargs).call
  end

  # @param objects [Object, [Object]] the object(s) to be interrogated for
  #   String values to be added to the output String
  # @param attributes [Array, *args] a list of method calls to interrogate the
  #   given object(s) with
  # @param limit [Integer, nil] a given limit on the number of objects to
  #   interrogate
  # @param klass [String, Symbol] a preferred type name for identifying the
  #   given object(s) as
  def initialize(
        objects,
        attributes = ObjectIdentifier::Identifier.default_attributes,
        limit: nil,
        klass: KLASS_NOT_GIVEN)
    @objects = ObjectIdentifier::ArrayWrap.(objects)
    @attributes = ObjectIdentifier::ArrayWrap.(attributes)
    @limit = (limit || @objects.size).to_i
    @klass = klass
  end

  # Output the self-identifying string for the given object(s). Will either
  # return a single object representation or a list of object
  # representations, based on the number of objects we're identifying.
  #
  # @return [String] a string that identifies the object(s)
  def call
    return NO_OBJECTS_INDICATOR if @objects.empty?

    output_strings = @objects.first(@limit).map { |obj| format(obj) }
    output_strings << "... (#{truncated_objects_count} more)" if truncated?
    output_strings.join(", ")
  end

  private

  def format(object)
    return NO_OBJECTS_INDICATOR if blank?(object)

    "#{class_name(object)}[#{format_attributes(evaluate_attributes(object))}]"
  end

  # Simple version of Rails' Object#blank? method.
  def blank?(object)
    object.nil? || object == [] || object == {}
  end

  def class_name(object)
    klass_given? ? @klass : object.class.name
  end

  def klass_given?
    @klass != KLASS_NOT_GIVEN
  end

  def format_attributes(attributes_hash)
    return if attributes_hash.empty?

    attributes_formatter = determine_attributes_formatter(attributes_hash)
    attributes_hash.map(&attributes_formatter).join(", ")
  end

  def determine_attributes_formatter(attributes_hash)
    if attributes_hash.one?
      ->(_key, value) { value.inspect_lit }
    else
      ->(key, value) { "#{key}:#{value.inspect_lit}" }
    end
  end

  # @return [Hash]
  def evaluate_attributes(object)
    @attributes.each_with_object({}) { |key, acc|
      if object.respond_to?(key, :include_private)
        acc[key] = object.send(key)
      elsif key.to_s.start_with?("@")
        acc[key] = object.instance_variable_get(key)
      end
    }
  end

  def truncated_objects_count
    objects_count - @limit
  end

  def objects_count
    @objects_count ||= @objects.size
  end

  def truncated?
    truncated_objects_count.positive?
  end
end

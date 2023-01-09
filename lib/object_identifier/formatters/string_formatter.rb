# frozen_string_literal: true

# ObjectIdentifier::StringFormatter builds a String to identify the
# given object(s).
class ObjectIdentifier::StringFormatter
  NO_OBJECTS_INDICATOR = "[no objects]"

  def self.call(
        objects,
        parameters = ObjectIdentifier::Identifier.buid_parameters)
    new(objects, parameters).call
  end

  # @param objects [Object, [Object, ...]] the object(s) to be interrogated for
  #   String values to be added to the output String
  # @param parameters [ObjectIdentifier::Identifier::Parameters]
  def initialize(
        objects,
        parameters = ObjectIdentifier::Identifier.buid_parameters)
    @objects = ObjectIdentifier::ArrayWrap.(objects)
    @parameters = parameters
  end

  # Output the self-identifying string for the given object(s). Will either
  # return a single object representation or a list of object
  # representations, based on the number of objects we're identifying.
  #
  # @return [String] a string that identifies the object(s)
  def call
    if @objects.none?
      NO_OBJECTS_INDICATOR
    elsif @objects.one?
      format_single_object
    else # @objects.size > 1
      format_multiple_objects
    end
  end

  private

  def format_single_object(object = @objects.first)
    SingleObject.(object, @parameters)
  end

  def format_multiple_objects
    Collection.(@objects, @parameters)
  end

  # ObjectIdentifier::StringFormatter::Collection formats a collection-specific
  # identification String, which will also necessarily be composed of
  # {ObjectIdentifier::StringFormatter::SingleObject} identification Strings.
  class Collection
    # @return [String] the self-identifying String for the passed in object.
    def self.call(*args)
      new(*args).call
    end

    # @param objects [Object, [Object, ...]] the object(s) to be interrogated
    #   for String values to be added to the output String
    # @param parameters [ObjectIdentifier::Identifier::Parameters]
    def initialize(objects, parameters)
      @objects = objects
      @parameters = parameters
    end

    def call
      output_strings =
        @objects.first(limit).map { |obj| format_single_object(obj) }
      output_strings << "... (#{truncated_objects_count} more)" if truncated?
      output_strings.join(", ")
    end

    private

    def format_single_object(object = @objects.first)
      SingleObject.(object, @parameters)
    end

    def limit
      @parameters.limit { objects_count }
    end

    def truncated_objects_count
      @truncated_objects_count ||= objects_count - limit
    end

    def objects_count
      @objects_count ||= @objects.size
    end

    def truncated?
      truncated_objects_count.positive?
    end
  end

  # ObjectIdentifier::StringFormatter::SingleObject formats a
  # single-object-specific identification String.
  class SingleObject
    # @return [String] the self-identifying String for the passed in object.
    def self.call(*args)
      new(*args).call
    end

    # @param object [Object] the object to be interrogated for String values to
    #   be added to the output String
    # @param parameters [ObjectIdentifier::Identifier::Parameters]
    def initialize(object, parameters)
      @object = object
      @parameters = parameters
    end

    # @return [String] the self-identifying String for {@object}.
    def call
      return NO_OBJECTS_INDICATOR if blank?

      "#{class_name}[#{formatted_attributes}]"
    end

    private

    # Simple version of Rails' Object#blank? method.
    def blank?
      @object.nil? || @object == [] || @object == {}
    end

    def class_name
      @parameters.klass { @object.class.name }
    end

    def formatted_attributes
      return if attributes_hash.empty?

      attributes_hash.map(&attributes_formatter).join(", ")
    end

    def attributes_formatter
      @attributes_formatter ||=
        if attributes_hash.one?
          ->(_key, value) { value.inspect_lit }
        else # attributes_hash.size > 1
          ->(key, value) { "#{key}:#{value.inspect_lit}" }
        end
    end

    # @return [Hash]
    def attributes_hash
      @attributes_hash ||=
        attributes.each_with_object({}) { |key, acc|
          if @object.respond_to?(key, :include_private)
            acc[key] = @object.__send__(key)
          elsif key.to_s.start_with?("@")
            acc[key] = @object.instance_variable_get(key)
          end
        }
    end

    def attributes
      @parameters.attributes
    end
  end
end

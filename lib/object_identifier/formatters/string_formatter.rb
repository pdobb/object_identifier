# frozen_string_literal: true

# ObjectIdentifier::StringFormatter builds a String to identify the
# given object(s).
class ObjectIdentifier::StringFormatter < ObjectIdentifier::BaseFormatter
  # The String to output when {#objects} is empty.
  NO_OBJECTS_INDICATOR = "[no objects]"

  # Output the self-identifying string for the given object(s). Will either
  # return a single object representation or a list of object
  # representations, based on the number of objects we're identifying.
  #
  # @return [String] A string that identifies the object(s).
  def call
    if objects.none?
      NO_OBJECTS_INDICATOR
    elsif objects.one?
      format_item
    else # objects.size > 1
      format_collection
    end
  end

  private

  def format_item(object = objects.first)
    Item.new(object, parameters).call
  end

  def format_collection
    Collection.new(objects, parameters).call
  end

  # ObjectIdentifier::StringFormatter::Collection formats a collection-specific
  # identification String, which will also necessarily be composed of
  # {ObjectIdentifier::StringFormatter::Item} identification Strings.
  class Collection
    attr_reader :objects,
                :parameters

    # @param objects [Object, [Object, ...]] the object(s) to be interrogated
    #   for String values to be added to the output String
    # @param parameters [ObjectIdentifier::Parameters]
    def initialize(objects, parameters)
      @objects = objects
      @parameters = parameters
    end

    # Build a comma-separated list of formatted item Strings representing the
    # given objects.
    #
    # @return [String]
    def call
      parts = objects.first(limit).map! { |obj| format_item(obj) }
      parts << "... (#{truncated_objects_count} more)" if truncated?
      parts.join(", ")
    end

    private

    def format_item(object)
      Item.new(object, parameters).call
    end

    def limit
      parameters.limit { objects_count }
    end

    def truncated?
      truncated_objects_count.positive?
    end

    def truncated_objects_count
      @truncated_objects_count ||= objects_count - limit
    end

    def objects_count
      @objects_count ||= objects.size
    end
  end

  # ObjectIdentifier::StringFormatter::Item formats a single-object-specific
  # identification String.
  class Item
    attr_reader :object,
                :parameters

    # @param object [Object] The object to be interrogated for String values to
    #   be added to the output String.
    # @param parameters [ObjectIdentifier::Parameters]
    def initialize(object, parameters)
      @object = object
      @parameters = parameters
    end

    # @return [String] The self-identifying String for {#object}.
    def call
      return NO_OBJECTS_INDICATOR if blank?

      "#{class_name}[#{formatted_attributes}]"
    end

    private

    # :reek:NilCheck

    # Simple version of Rails' Object#blank? method.
    def blank?
      object.nil? || object == [] || object == {}
    end

    def class_name
      parameters.class { object.class.name }
    end

    def formatted_attributes
      attributes_hash.map(&attributes_formatter).join(", ")
    end

    # :reek:DuplicateMethodCall

    def attributes_formatter
      @attributes_formatter ||=
        if attributes_hash.one?
          ->(_key, value) { value.inspect }
        else # attributes_hash.size > 1
          ->(key, value) { "#{key}:#{value.inspect}" }
        end
    end

    # :reek:ManualDispatch

    # @return [Hash]
    def attributes_hash
      @attributes_hash ||=
        attributes.each_with_object({}) { |key, acc|
          if object.respond_to?(key, :include_private)
            acc[key] = object.__send__(key)
          elsif key.to_s.start_with?("@")
            acc[key] = object.instance_variable_get(key)
          end
        }
    end

    def attributes
      parameters.attributes
    end
  end
end

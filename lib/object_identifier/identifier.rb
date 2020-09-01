# frozen_string_literal: true

module ObjectIdentifier
  # ObjectIdentifier::Identifier manages construction of the inspect String.
  class Identifier
    NO_OBJECTS_INDICATOR = "[no objects]"

    # Class method for constructing a self-identifying string for any given
    # object or collection of objects.
    #
    # @overload self.identify(obj, *args)
    #   @param obj [Object] the object to identify
    #   @param args [*] (optional) a list of arguments to identify for this
    #     object or for each object in this collection
    # @overload self.identify(obj, *args, options)
    #   @param obj [Object] the object to identify
    #   @param args [*] (optional) (default :id) a list of arguments to identify
    #     for this object
    #   @param [Hash] options the options for building a customized
    #     self-identifier
    #   @option options [String, nil] :klass object class name override
    #   @option options [Integer] :limit maximum number of objects to display
    #     from a collection
    #
    # @return [String] a self-identifying string like `Class[id:1, name:'temp']`
    #
    # @example
    #   ObjectIdentifier::Identifier.identify(
    #     OpenStruct.new(a: 1, b: '2', c: :"3"), :a, :b, :c)
    #   # => "OpenStruct[a:1, b:\"2\", c::\"3\"]"
    #
    #   ObjectIdentifier::Identifier.identify(1, :to_s)
    #   # => "Integer[to_s:\"1\"]"
    #   ObjectIdentifier::Identifier.identify(nil)
    #   # => "[no objects]"
    #
    #   ObjectIdentifier::Identifier.identify(%w(1 2), :to_i, :to_f)
    #   # => "String[to_i:1, to_f:1.0], String[to_i:2, to_f:2.0]"
    #
    #   ObjectIdentifier::Identifier.identify((1..10).to_a, :to_f, limit: 2)
    #   # => "Integer[to_f:1.0], Integer[to_f:2.0], ... (8 more)"
    def self.identify(object, *args)
      new(object, *args).to_s
    end

    def initialize(objects, *args, limit: nil, klass: :not_given)
      @objects = ArrayWrap.call(objects)
      @attributes = args.empty? ? [:id] : args
      @limit = (limit || @objects.size).to_i
      @klass = klass
    end

    # Output the self-identifying string for an instance of
    # ObjectIdentifier::Identifier. Will either return a single object
    # representation or a list of object representations, based on the number of
    # objects we're identifying.
    #
    # @return [String] a string representing the object or list of objects
    def to_s
      if many?
        format_multiple_objects
      else
        format_single_object
      end
    end

    private

    def format_multiple_objects
      objects =
        @objects.first(@limit).map { |obj| format(obj) }

      objects << "... (#{truncated_objects_count} more)" if truncated?

      objects.join(", ")
    end

    def format_single_object
      object = @objects.first if @objects.respond_to?(:first)

      format(object)
    end

    def format(object)
      return NO_OBJECTS_INDICATOR if blank?(object)

      "#{class_name(object)}[#{format_attributes(evaluate_attributes(object))}]"
    end

    def format_attributes(attributes_hash)
      return if attributes_hash.empty?

      attributes_hash.
        map(&format_attributes_map_block(attributes_hash)).
        join(", ")
    end

    def format_attributes_map_block(attributes_hash)
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

    def class_name(object)
      klass_given? ? @klass : object.class.name
    end

    def truncated_objects_count
      objects_count - @limit
    end

    def objects_count
      @objects_count ||= @objects.size
    end

    def klass_given?
      @klass != :not_given
    end

    def blank?(object)
      object.nil? || object == [] || object == {}
    end

    def many?
      objects_count > 1
    end

    def truncated?
      truncated_objects_count.positive?
    end

    # ObjectIdentifier::Identifier::ArrayWrap mirrors the implementation of
    # Rails' {Array.wrap} method. This allows us to get around objects that
    # respond to `to_a` (such as Struct) and, instead, utilize either `to_ary`
    # or just actually wrapping the object in an Array.
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
end

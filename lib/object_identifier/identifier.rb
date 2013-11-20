require "naught"

module ObjectIdentifier
  class Identifier
    NullObject = Naught.build
    include NullObject::Conversions

    # Class method for constructing a self-identifying string for any given
    # object or collection of objects.
    # @overload self.identify(obj, *args)
    #   @param obj [Object] the object to identify
    #   @param args [*] (optional) a list of arguments to identify for this object
    #     or for each object in this collection
    # @overload self.identify(obj, *args, options)
    #   @param obj [Object] the object to identify
    #   @param args [*] (optional) (default :id) a list of arguments to identify for this object
    #   @param [Hash] options the options for building a customized self-identifier
    #   @option options [String, nil] :klass object class name override
    #   @option options [Fixnum] :limit maximum number of objects to display from a collection
    # @return [String] a self-identifying string like `Class[id:1, name:'temp']`
    # @example
    #   ObjectIdentifier::Identifier.identify(OpenStruct.new(a: 1, b: '2', c: :"3"), :a, :b, :c) # => "OpenStruct[a:1, b:\"2\", c::\"3\"]"
    #   ObjectIdentifier::Identifier.identify(1, :to_s) # => "Fixnum[to_s:\"1\"]"
    #   ObjectIdentifier::Identifier.identify(nil) # => "[no objects]"
    #   ObjectIdentifier::Identifier.identify(%w(1 2 3), :to_i, :to_f) # => "String[to_i:1, to_f:1.0], String[to_i:2, to_f:2.0], String[to_i:3, to_f:3.0]"
    #   ObjectIdentifier::Identifier.identify((1..10).to_a, :to_f, limit: 2) # => "Fixnum[to_f:1.0], Fixnum[to_f:2.0], ... (8 more)"
    def self.identify(obj, *args)
      new(Array.wrap(obj), *args).to_s
    end

    def initialize(objects, *args)
      @objects    = objects
      @options    = args.extract_options!
      @attributes = args.empty? ? [:id] : args
    end

    # Output the self-identifying string for an instance of
    # ObjectIdentifier::Identifier. Will either return a single object representation
    # or a list of object representations, based on the number of objects we're
    # identifying.
    # @return [String] a string representing the object or list of objects
    def to_s
      if multiple_objects_to_identify?
        format_multiple_objects
      else
        format_single_object
      end
    end

    private

    def format_multiple_objects
      objects = @objects.first(limit).map do |obj|
        format_with_attributes(obj)
      end.join(", ")

      if any_objects_abbreviated?
        objects << ", ... (#{number_of_abbreviated_objects} more)"
      end

      objects
    end

    def format_single_object
      obj = if nil_or_empty_array?(@objects)
              @objects
            else
              @objects.first
            end
      format_with_attributes(obj)
    end

    def multiple_objects_to_identify?
      @objects.try(:many?)
    end

    def limit
      @options[:limit] || @objects.size
    end

    def limit_given?
      @options.has_key?(:limit)
    end

    def any_objects_abbreviated?
      limit_given? && number_of_abbreviated_objects > 0
    end

    def number_of_abbreviated_objects
      @objects.size - Maybe(@options[:limit]).to_i
    end

    def format_with_attributes(object)
      if nil_or_empty_array?(object)
        format_empty(object)
      else
        attrs = @attributes.each_with_object({}) do |key, memo|
          memo[key] = object.send(key) if object.respond_to?(key)
        end
        "#{class_name_of(object)}[#{attribute_formatter(attrs)}]"
      end
    end

    def format_empty(object)
      @options.has_key?(:klass) ? "#{@options[:klass]}[]" : "[no objects]"
    end

    def attribute_formatter(hash)
      return if hash.empty?

      hash.inject([]) do |memo, (key, value)|
        memo << "#{key}:#{value.inspect_lit}"
      end.join(", ")
    end

    def nil_or_empty_array?(object)
      object.nil? || object == []
    end

    def class_name_of(object)
      @options.has_key?(:klass) ? @options[:klass] : object.class.name
    end
  end
end

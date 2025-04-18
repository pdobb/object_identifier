# frozen_string_literal: true

# Reopen the core Object class to add {#identify} to all objects.
class Object
  # Instance method for constructing a self-identifying string for any given
  # object or list of objects.
  #
  # @overload identify(*args)
  #   @param args [*] (optional) a list of arguments to identify for this object
  #     or for each object in this collection
  # @overload identify(*args, options)
  #   @param args [*] (optional) (default: :id) a list of arguments to identify
  #     for this object
  #   @param [Hash] options the options for building a customized
  #     self-identifier
  #   @option options [String, nil] :class object class name override
  #   @option options [Integer] :limit maximum number of objects to display from
  #     a collection
  #
  # @return [String] a self-identifying string
  #
  # @example
  #   Struct.new(:a, :b, :c)[1, "2", :"3"].identify(:a, :b, :c, class: "Struct")
  #   => "Struct[a:1, b:\"2\", c::\"3\"]"

  #   Data.define(:a, :b, :c)[1, "2", :"3"].identify(:a, :b, :c, class: "Data")
  #   # => "Data[a:1, b:\"2\", c::\"3\"]"
  #
  #   1.identify(:to_s) # => "Integer[to_s:\"1\"]"
  #   nil.identify      # => "[no objects]"
  #
  #   %w(1 2).identify(:to_i, :to_f)
  #   # => "String[to_i:1, to_f:1.0], String[to_i:2, to_f:2.0]"
  #
  #   (1..10).to_a.identify(:to_f, limit: 2)
  #   # => "Integer[to_f:1.0], Integer[to_f:2.0], ... (8 more)"
  def identify(...)
    ObjectIdentifier.(self, ...)
  end
end

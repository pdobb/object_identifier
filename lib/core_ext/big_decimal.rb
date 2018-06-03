require "bigdecimal"

# Reopen the core BigDecimal class to represent {#inspect_lit}.
class BigDecimal
  # Formats this BigDecimal as an object-type-revealing String.
  #
  # @return [String] a String representation of this BigDecimal object
  #
  # @example
  #   BigDecimal.new(1).inspect_lit          # => "<BD:1.0>"
  #   BigDecimal.new(99.999, 5).inspect_lit  # => "<BD:99.999>"
  def inspect_lit
    "<BD:#{self}>"
  end
end

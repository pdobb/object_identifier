class BigDecimal
  # Formats this BigDecimal to look like a float, which is at least readable.
  # @return [String] a String representation of this BigDecimal object (via float)
  # @example
  #   BigDecimal.new(1).inspect_lit # => "1.0"
  def inspect_lit
    to_s
  end
end

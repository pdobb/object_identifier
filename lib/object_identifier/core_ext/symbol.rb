class Symbol
  # Formats this symbol to look like a symbol literal so that object type will
  # be inherently obvious when used in logging methods, etc.
  #
  # @return [String] a symbol literal representation of this object
  #
  # @example
  #   :test.inspect_lit     # => ":\"test\"" (or ':"test"')
  #   :"ta-da!".inspect_lit # => ":\"ta-da!\"" (or ':"ta-da!"')
  def inspect_lit
    %(:"#{to_s}")
  end
end

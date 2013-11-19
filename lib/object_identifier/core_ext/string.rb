class String
  # Formats this string to look like a string literal so that object type will
  # be inherently obvious when used in logging methods, etc.
  # @return [String] a string literal representation of this object
  # @example
  #   "test".inspect_lit # => "\"test\"" (or '"test"')
  #   "1".inspect_lit # => "\"1\"" (or '"1"')
  #   "12.3".inspect_lit # => "\"12.3\"" (or '"12.3"')
  def inspect_lit
    %("#{to_s}")
  end
end

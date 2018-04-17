class String
  # Formats self to look like a String literal so that object type will be
  # inherently obvious when inspected.
  #
  # @return [String] a String-literal representation of this object
  #
  # @example
  #   "test".inspect_lit  # => "\"test\"" (i.e. '"test"')
  #   "1".inspect_lit     # => "\"1\""    (i.e. '"1"')
  #   "12.3".inspect_lit  # => "\"12.3\"" (i.e. '"12.3"')
  def inspect_lit
    %("#{to_s}")
  end
end

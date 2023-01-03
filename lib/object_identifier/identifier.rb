# frozen_string_literal: true

# ObjectIdentifier::Identifier manages construction of identification outputs
# using the passed in formatter object.
class ObjectIdentifier::Identifier
  # Note: `kargs` may be specific to the Formatter being called.
  def self.call(
        objects,
        *attributes,
        formatter: default_formatter,
        **formatter_options)
    formatter.(objects, *attributes, **formatter_options)
  end

  def self.default_formatter
    ObjectIdentifier::Formatters::StringFormatter
  end

  def self.default_attributes
    [:id]
  end
end

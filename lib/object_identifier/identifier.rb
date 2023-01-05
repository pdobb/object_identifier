# frozen_string_literal: true

# ObjectIdentifier::Identifier manages construction of identification outputs
# using the passed in formatter_class.
class ObjectIdentifier::Identifier
  # NOTE: `kargs` may be specific to the Formatter being called.
  def self.call(
        objects,
        *attributes,
        formatter_class: default_formatter_class,
        **formatter_options)
    formatter_class.(objects, *attributes, **formatter_options)
  end

  def self.default_formatter_class
    ObjectIdentifier.configuration.formatter_class
  end

  def self.default_attributes
    ObjectIdentifier.configuration.default_attributes
  end
end

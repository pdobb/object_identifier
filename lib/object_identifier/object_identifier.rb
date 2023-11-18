# frozen_string_literal: true

# ObjectIdentifier is the top-level namespace/module for this gem.
module ObjectIdentifier
  # :reek:LongParameterList

  # ObjectIdentifier.call is the main entry point for use of this gem. In
  # typical usage, however, this method will almost exclusively just be called
  # by {Object#identify}, as defined in lib/core_ext/object.rb.
  def self.call(
        objects,
        *attributes,
        formatter_class: default_formatter_class,
        **formatter_options)

    parameters =
      ObjectIdentifier::Parameters.build(
        attributes: attributes,
        formatter_options: formatter_options)

    formatter_class.(objects, parameters: parameters)
  end
end

# frozen_string_literal: true

# ObjectIdentifier::BaseFormatter is an abstract base class for formatters.
class ObjectIdentifier::BaseFormatter
  attr_reader :objects,
              :parameters

  # A shortcut for calling `new(...).call`.
  def self.call(...)
    new(...).call
  end

  # @param objects [Object, [Object, ...]] The object(s) to be interrogated for
  #   String values to be added to the output String.
  # @param parameters [ObjectIdentifier::Parameters]
  def initialize(objects, parameters: ObjectIdentifier::Parameters.build)
    @objects = ObjectIdentifier::ArrayWrap.(objects)
    @parameters = parameters
  end

  def call
    raise NotImplementedError
  end
end

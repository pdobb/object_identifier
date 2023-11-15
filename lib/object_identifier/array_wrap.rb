# frozen_string_literal: true

# ObjectIdentifier::ArrayWrap mirrors the implementation of Rails'
# Array.wrap method. This allows us to get around objects that respond to
# `to_a` (such as Struct) and, instead, either utilize `to_ary` or just
# actually wrap the object in an Array ourselves.
class ObjectIdentifier::ArrayWrap
  # :reek:NilCheck
  # :reek:ManualDispatch
  def self.call(object)
    if object.nil?
      []
    elsif object.respond_to?(:to_ary)
      object.to_ary || [object]
    else
      [object]
    end
  end
end

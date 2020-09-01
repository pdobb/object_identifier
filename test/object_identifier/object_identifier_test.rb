# frozen_string_literal: true

require "test_helper"

class ObjectIdentifierTest < Minitest::Spec
  describe ObjectIdentifier do
    let(:klazz) { ObjectIdentifier }

    it "has a VERSION" do
      value(klazz::VERSION).wont_be_nil
    end
  end
end

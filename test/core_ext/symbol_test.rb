# frozen_string_literal: true

require "test_helper"

class SymbolTest < Minitest::Spec
  describe Symbol do
    describe "#inspect_lit" do
      it "quotes symbol values after colon" do
        value(:symbol.inspect_lit).must_equal(%(:"symbol"))
      end
    end
  end
end

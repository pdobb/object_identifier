# frozen_string_literal: true

require "test_helper"

class BigDecimalTest < Minitest::Spec
  describe BigDecimal do
    describe "#inspect_lit" do
      it "returns the same as #to_s" do
        [1, 1.0, 0, 99.9999].each do |val|
          bd_val = BigDecimal(val, 10)
          value(bd_val.inspect_lit).must_equal("<BD:#{bd_val}>")
        end
      end
    end
  end
end

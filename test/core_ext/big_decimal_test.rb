require "test_helper"

describe BigDecimal do
  describe "#inspect_lit" do
    it "returns the same as #to_s" do
      [1, 1.0, 0, 99.9999].each do |val|
        bd_val = BigDecimal.new(val, 10)
        bd_val.inspect_lit.must_equal "<BD:#{bd_val}>"
      end
    end
  end
end

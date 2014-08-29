require "test_helper"

describe Symbol do
  describe "#inspect_lit" do
    it "quotes symbol values after colon" do
      assert :symbol.inspect_lit == %(:"symbol")
    end
  end
end

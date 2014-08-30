require "test_helper"

describe String do
  describe "#inspect_lit" do
    it "quotes string values" do
      "string".inspect_lit.must_equal %("string")
    end
  end
end

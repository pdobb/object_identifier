require "test_helper"

describe String do
  describe "#inspect_lit" do
    it "quotes string values" do
      assert "string".inspect_lit == %("string")
    end
  end
end

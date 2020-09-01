# frozen_string_literal: true

require "test_helper"

describe String do
  describe "#inspect_lit" do
    it "quotes string values" do
      value("string".inspect_lit).must_equal(%("string"))
    end
  end
end

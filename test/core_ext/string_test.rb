# frozen_string_literal: true

require "test_helper"

class StringTest < Minitest::Spec
  describe String do
    describe "#inspect_lit" do
      it "quotes string values" do
        _("string".inspect_lit).must_equal(%("string"))
      end
    end
  end
end

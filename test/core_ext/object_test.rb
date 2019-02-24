# frozen_string_literal: true

require "test_helper"

describe Object do
  it "responds to #inspect_lit" do
    assert Object.new.respond_to?(:inspect_lit)
  end

  it "responds to #identify" do
    assert Object.new.respond_to?(:identify)
  end
end

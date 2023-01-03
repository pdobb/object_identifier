# frozen_string_literal: true

require "test_helper"

describe Object do
  subject { Object.new }

  describe "#inspect_lit" do
    before do
      MuchStub.on_call(subject, :inspect) { |call|
        @object_inspect_call = call
      }
    end

    it "calls inspect on self" do
      subject.inspect_lit

      value(@object_inspect_call.args).must_equal([])
    end
  end

  describe "#identify" do
    before do
      MuchStub.on_call(ObjectIdentifier::Identifier, :identify) { |call|
        @object_identifier_identifier_call = call
      }
    end

    it "calls ObjectIdentifier::Identifier, passing self along" do
      subject.identify

      value(@object_identifier_identifier_call.pargs).must_equal([subject])
    end

    it "also passes along args and kargs when given" do
      attributes = %i[arg1 arg2]
      options = { limit: 9 }

      subject.identify(attributes, **options)

      value(@object_identifier_identifier_call.pargs).must_equal([subject, attributes])
      value(@object_identifier_identifier_call.kargs).must_equal(options)
    end
  end
end

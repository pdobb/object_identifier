# frozen_string_literal: true

require "test_helper"

class ObjectTest < Minitest::Spec
  describe Object do
    subject { Object.new }

    describe "#identify" do
      before do
        MuchStub.on_call(ObjectIdentifier, :call) { |call|
          @object_identifier_identifier_call = call
        }
      end

      it "calls ObjectIdentifier, passing self along" do
        subject.identify

        _(@object_identifier_identifier_call.pargs).must_equal([subject])
      end

      it "also passes along args and kwargs when given" do
        attributes = %i[arg1 arg2]
        options = { limit: 9 }

        subject.identify(attributes, **options)

        _(@object_identifier_identifier_call.pargs).must_equal(
          [subject, attributes])
        _(@object_identifier_identifier_call.kargs).must_equal(options)
      end
    end
  end
end

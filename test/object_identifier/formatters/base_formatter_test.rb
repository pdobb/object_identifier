# frozen_string_literal: true

require "test_helper"

class ObjectIdentifier::BaseFormatterTest < Minitest::Spec
  # ObjectIdentifier::BaseFormatterTest::TestStruct is a Test Dummy.
  TestStruct = Struct.new(:id)

  describe "ObjectIdentifier::BaseFormatter" do
    describe ".call" do
      before do
        MuchStub.tap(ObjectIdentifier::BaseFormatter, :new) { |value, *args|
          @object_identifier_base_formatter_called_with = args
          MuchStub.(value, :call) { "FAKE_CALL_RESULT" }
        }
      end

      subject { ObjectIdentifier::BaseFormatter }

      it "forwards to #call" do
        result = subject.call(1, parameters: [2])
        value(@object_identifier_base_formatter_called_with).must_equal(
          [1, { parameters: [2] }])
        value(result).must_equal("FAKE_CALL_RESULT")
      end
    end

    describe "#call" do
      subject { ObjectIdentifier::BaseFormatter.new(1, parameters: [2]) }

      it "raises NotImplementedError" do
        value(-> { subject.call }).must_raise(NotImplementedError)
      end
    end
  end
end

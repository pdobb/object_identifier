# frozen_string_literal: true

require "test_helper"

class ObjectIdentifier::IdentifierTest < Minitest::Spec
  # ObjectIdentifier::IdentifierTest::DefaultFormatter is a Test Dummy.
  class DefaultFormatter
    def self.call(*)
    end
  end

  # ObjectIdentifier::IdentifierTest::CustomFormatter is a Test Dummy.
  class CustomFormatter
    def self.call(*)
    end
  end

  describe ObjectIdentifier::Identifier do
    before do
      MuchStub.on_call(CustomFormatter, :call) { |call|
        @custom_formatter_call = call
      }
      MuchStub.on_call(
        ObjectIdentifier::Identifier,
        :default_formatter_class) { |_call|
          @default_formatter_class_called = true
          DefaultFormatter
        }
      MuchStub.tap_on_call(
        ObjectIdentifier::Identifier::Parameters,
        :new) { |_value, call|
          @parameters_initializer_call = call
        }
    end

    let(:klazz) { ObjectIdentifier::Identifier }

    let(:objects) { ["a", 1, Struct.new(:id), [], {}].sample }
    let(:custom_formatter_class) { CustomFormatter }
    let(:formatter_options) { { limit: 9, klass: "TestClass" } }
    let(:custom_attributes) { %i[id name] }

    subject { klazz }

    describe ".call" do
      it "calls the default formatter + attributes, "\
         "GIVEN no custom formatter nor custom attributes" do
        subject.call(objects)

        value(@custom_formatter_call).must_be_nil
        value(@default_formatter_class_called).must_equal(true)

        value(@parameters_initializer_call.kargs).must_equal(
          { attributes: %i[id], formatter_options: {} })
      end

      it "calls the given formatter + attributes + options, "\
         "GIVEN a custom formatter + custom attributes + custom options" do
        subject.call(
          objects,
          custom_attributes,
          formatter_class: custom_formatter_class,
          **formatter_options)

        value(@custom_formatter_call.pargs.size).must_equal(2)
        value(@custom_formatter_call.pargs.first).must_equal(objects)
        value(@custom_formatter_call.pargs[1]).must_be_instance_of(
          ObjectIdentifier::Identifier::Parameters)
        value(@custom_formatter_call.kargs).must_be_nil

        value(@parameters_initializer_call.kargs).must_equal(
          {
            attributes: custom_attributes,
            formatter_options: formatter_options
          })
      end
    end
  end
end

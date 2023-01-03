# frozen_string_literal: true

require "test_helper"

class ObjectIdentifier::IdentifierTest < Minitest::Spec
  class CustomFormatter
    def self.call(*)
    end
  end

  describe ObjectIdentifier::Identifier do
    before do
      MuchStub.on_call(CustomFormatter, :call) { |call|
        @custom_formatter_call = call
      }
      MuchStub.
        on_call(ObjectIdentifier::Identifier, :default_attributes) { |call|
          @default_attributes_call = call
          custom_attributes
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
         "GIVEN no formatter nor attributes" do
        subject.call(objects)
        value(@custom_formatter_call).must_be_nil
        value(@default_attributes_call).wont_be_nil
      end

      it "calls the given formatter, GIVEN a formatter" do
        subject.call(objects, formatter: custom_formatter_class)
        value(@custom_formatter_call.args).must_equal([objects])
        value(@custom_formatter_call.kargs).must_be_nil
      end

      it "doesn't call the default attributes, GIVEN attributes" do
        subject.call(objects, custom_attributes)
        value(@default_attributes_call).must_be_nil
      end

      it "calls the given formatter + options, GIVEN a formatter + options" do
        subject.call(
          objects,
          formatter: custom_formatter_class,
          **formatter_options)
        value(@custom_formatter_call.pargs).must_equal([objects])
        value(@custom_formatter_call.kargs).must_equal(formatter_options)
      end
    end
  end
end

# frozen_string_literal: true

require "test_helper"

class ObjectIdentifierTest < Minitest::Spec
  # ObjectIdentifierTest::CustomFormatter is a Test Double.
  class CustomFormatter < ObjectIdentifier::BaseFormatter
    def call(*)
      "FAKE_CALL_RESULT"
    end
  end

  describe "ObjectIdentifier" do
    let(:unit_class) { ObjectIdentifier }

    let(:objects) { ["a", 1, Struct.new(:id), [], {}].sample }
    let(:default_formatter_class) { unit_class::StringFormatter }
    let(:custom_formatter_class) { CustomFormatter }
    let(:custom_formatter_options) { { limit: 9, klass: "TestClass" } }
    let(:custom_attributes) { %i[id name] }

    subject { unit_class }

    it "has a VERSION" do
      _(unit_class::VERSION).wont_be_nil
    end

    describe ".call" do
      before do
        MuchStub.tap_on_call(unit_class::Parameters, :build) { |_value, call|
          @parameters_build_call = call
        }
      end

      context "GIVEN no custom formatter nor custom attributes" do
        before do
          MuchStub.tap(default_formatter_class, :call) { |*|
            @default_formatter_class_called = true
          }
        end

        it "calls the default formatter + attributes" do
          result = subject.call(objects)
          _(result).must_be_instance_of(String)

          _(@default_formatter_class_called).must_equal(true)
          _(@parameters_build_call.kargs).must_equal({
            attributes: [],
            formatter_options: {},
          })
        end
      end

      context "GIVEN a custom formatter + attributes + formatter options" do
        before do
          MuchStub.tap(custom_formatter_class, :call) { |*|
            @custom_formatter_class_called = true
          }
        end

        it "calls the given formatter + attributes + options" do
          result =
            subject.call(
              objects,
              custom_attributes,
              formatter_class: custom_formatter_class,
              **custom_formatter_options)
          _(result).must_equal("FAKE_CALL_RESULT")

          _(@custom_formatter_class_called).must_equal(true)
          _(@parameters_build_call.kargs).must_equal(
            {
              attributes: custom_attributes,
              formatter_options: custom_formatter_options,
            })
        end
      end
    end
  end
end

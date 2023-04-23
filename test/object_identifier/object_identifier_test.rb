# frozen_string_literal: true

require "test_helper"

class ObjectIdentifierTest < Minitest::Spec
  # ObjectIdentifierTest::CustomFormatter is a Test Double.
  class CustomFormatter < ObjectIdentifier::BaseFormatter
    def call(*)
    end
  end

  describe "ObjectIdentifier" do
    let(:unit_class) { ObjectIdentifier }
    let(:configuration_unit_class) { unit_class::Configuration }

    let(:objects) { ["a", 1, Struct.new(:id), [], {}].sample }
    let(:default_formatter_class) { unit_class::StringFormatter }
    let(:custom_formatter_class) { CustomFormatter }
    let(:default_formatter_options) { {} }
    let(:custom_formatter_options) { { limit: 9, klass: "TestClass" } }
    let(:default_attributes) { %i[id] }
    let(:custom_attributes) { %i[id name] }

    subject { unit_class }

    it "has a VERSION" do
      value(unit_class::VERSION).wont_be_nil
    end

    describe ".call" do
      before do
        MuchStub.tap_on_call(
          ObjectIdentifier::Parameters,
          :build) { |_value, call|
            @parameters_build_call = call
          }
      end

      context "GIVEN no custom formatter nor custom attributes" do
        before do
          MuchStub.tap(ObjectIdentifier, :default_formatter_class) { |*|
            @default_formatter_class_called = true
          }

          it "calls the default formatter + attributes" do
            subject.call(objects)

            value(@default_formatter_class_called).must_equal(true)
            value(@parameters_build_call.kargs).must_equal({
              attributes: default_attributes,
              formatter_options: default_formatter_options
            })
          end
        end
      end

      context "GIVEN a custom formatter + custom attributes + custom formatter options" do
        before do
          MuchStub.on_call(custom_formatter_class, :call) { |call|
            @custom_formatter_call = call
          }
        end

        it "calls the given formatter + attributes + options" do
          subject.call(
            objects,
            custom_attributes,
            formatter_class: custom_formatter_class,
            **custom_formatter_options)

          value(@custom_formatter_call.pargs.size).must_equal(2)
          value(@custom_formatter_call.pargs.first).must_equal(objects)
          value(@custom_formatter_call.pargs[1]).must_be_instance_of(
            ObjectIdentifier::Parameters)
          value(@custom_formatter_call.kargs).must_be_nil

          value(@parameters_build_call.kargs).must_equal(
            {
              attributes: custom_attributes,
              formatter_options: custom_formatter_options
            })
        end
      end
    end

    describe ".default_formatter_class" do
      subject { unit_class }

      it "returns the expected constant" do
        value(subject.default_formatter_class).must_equal(default_formatter_class)
      end
    end

    describe ".default_attributes" do
      subject { unit_class }

      it "returns the expected constant" do
        value(subject.default_attributes).must_equal(default_attributes)
      end
    end

    describe ".configuration" do
      subject { unit_class }

      it "returns an ObjectInspector::Configuration object" do
        value(subject.configuration).must_be_kind_of(configuration_unit_class)
      end

      it "contains the expected default values" do
        configuration = subject.configuration

        value(configuration.formatter_class).must_equal(default_formatter_class)
        value(configuration.default_attributes).must_equal(default_attributes)
      end
    end

    describe ".configure" do
      subject { unit_class }

      context "GIVEN a custom configuration" do
        before do
          subject.configure do |config|
            config.formatter_class = custom_formatter_class
            config.default_attributes = custom_attributes
          end
        end

        after { subject.reset_configuration }

        it "sets custom configuration and converts values to Strings" do
          configuration = subject.configuration

          value(configuration.formatter_class).must_equal(custom_formatter_class)
          value(configuration.default_attributes).must_equal(
            custom_attributes)
        end
      end
    end

    describe ".reset_configuration" do
      subject { unit_class }

      it "resets the Configuration to the expected default values" do
        configuration = subject.configuration

        value(configuration.formatter_class).must_equal(default_formatter_class)
        value(configuration.default_attributes).must_equal(
          default_attributes)
      end
    end

    describe "ObjectIdentifier::Configuration" do
      describe "#formatter_class=" do
        subject { configuration_unit_class.new }

        context "GIVEN a Class constant" do
          it "sets the value as expected" do
            subject.formatter_class = custom_formatter_class
            value(subject.formatter_class).must_equal(custom_formatter_class)
          end
        end

        context "GIVEN a String" do
          it "raises TypeError" do
            value(-> { subject.formatter_class = "STRING" }).must_raise(
              TypeError)
          end
        end
      end
    end
  end
end

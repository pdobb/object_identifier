# frozen_string_literal: true

require "test_helper"

class ObjectIdentifierTest < Minitest::Spec
  # ObjectIdentifierTest::DefaultFormatter is a Test Dummy.
  class DefaultFormatter < ObjectIdentifier::BaseFormatter
    def call(*)
    end
  end

  # ObjectIdentifierTest::CustomFormatter is a Test Dummy.
  class CustomFormatter < ObjectIdentifier::BaseFormatter
    def call(*)
    end
  end

  describe "ObjectIdentifier" do
    let(:unit_class) { ObjectIdentifier }
    let(:configuration_unit_class) { unit_class::Configuration }

    let(:objects) { ["a", 1, Struct.new(:id), [], {}].sample }
    let(:default_formatter) { unit_class::StringFormatter }
    let(:custom_formatter) { CustomFormatter }
    let(:formatter_options) { { limit: 9, klass: "TestClass" } }
    let(:default_attributes) { %i[id] }
    let(:custom_attributes) { %i[id name] }

    subject { unit_class }

    it "has a VERSION" do
      value(unit_class::VERSION).wont_be_nil
    end

    describe ".call" do
      before do
        MuchStub.on_call(CustomFormatter, :call) { |call|
          @custom_formatter_call = call
        }
        MuchStub.on_call(ObjectIdentifier, :default_formatter_class) { |_call|
          @default_formatter_class_called = true
          DefaultFormatter
        }
        MuchStub.tap_on_call(
          ObjectIdentifier::Parameters,
          :new) { |_value, call|
            @parameters_initializer_call = call
          }
      end

      it "calls the default formatter + attributes, "\
         "GIVEN no custom formatter nor custom attributes" do
        subject.call(objects)

        value(@custom_formatter_call).must_be_nil
        value(@default_formatter_class_called).must_equal(true)

        value(@parameters_initializer_call.kargs).must_equal(
          { attributes: default_attributes, formatter_options: {} })
      end

      it "calls the given formatter + attributes + options, "\
         "GIVEN a custom formatter + custom attributes + custom options" do
        subject.call(
          objects,
          custom_attributes,
          formatter_class: custom_formatter,
          **formatter_options)

        value(@custom_formatter_call.pargs.size).must_equal(2)
        value(@custom_formatter_call.pargs.first).must_equal(objects)
        value(@custom_formatter_call.pargs[1]).must_be_instance_of(
          ObjectIdentifier::Parameters)
        value(@custom_formatter_call.kargs).must_be_nil

        value(@parameters_initializer_call.kargs).must_equal(
          {
            attributes: custom_attributes,
            formatter_options: formatter_options
          })
      end
    end

    describe ".default_formatter_class" do
      subject { unit_class }

      it "returns the expected constant" do
        value(subject.default_formatter_class).must_equal(default_formatter)
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

        value(configuration.formatter_class).must_equal(default_formatter)
        value(configuration.default_attributes).must_equal(default_attributes)
      end
    end

    describe ".configure" do
      subject { unit_class }

      context "GIVEN a custom configuration" do
        before do
          subject.configure do |config|
            config.formatter_class = CustomFormatter
            config.default_attributes = custom_attributes
          end
        end

        after { subject.reset_configuration }

        it "sets custom configuration and converts values to Strings" do
          configuration = subject.configuration

          value(configuration.formatter_class).must_equal(CustomFormatter)
          value(configuration.default_attributes).must_equal(
            custom_attributes)
        end
      end
    end

    describe ".reset_configuration" do
      subject { unit_class }

      it "resets the Configuration to the expected default values" do
        configuration = subject.configuration

        value(configuration.formatter_class).must_equal(default_formatter)
        value(configuration.default_attributes).must_equal(
          default_attributes)
      end
    end

    describe "ObjectIdentifier::Configuration" do
      describe "#formatter_class=" do
        subject { configuration_unit_class.new }

        context "GIVEN a Class constant" do
          it "sets the value as expected" do
            subject.formatter_class = CustomFormatter
            value(subject.formatter_class).must_equal(CustomFormatter)
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

# frozen_string_literal: true

require "test_helper"

class ObjectIdentifier::ParametersTest < Minitest::Spec
  # ObjectIdentifier::ParametersTest::CustomFormatter is a Test Dummy.
  module CustomFormatter
    def self.call(*)
    end
  end

  describe "ObjectIdentifier::Parameters" do
    let(:unit_class) { ObjectIdentifier::Parameters }

    let(:custom_attributes) { %i[id name] }

    describe "#new" do
      context "GIVEN no passed-in attributes" do
        subject { unit_class.new }

        it "sets sensible defaults, GIVEN" do
          _(subject.attributes).must_equal([])
          _(subject.limit).must_be_nil
          _(subject.class).must_be_nil
        end
      end

      context "GIVEN passed in options" do
        let(:formatter_options) {
          {
            limit: 9,
            class: CustomFormatter,
            unknown_key: "THIS KEY SHOULD BE IGNORED",
          }
        }

        subject {
          unit_class.new(
            attributes: custom_attributes,
            formatter_options: formatter_options)
        }

        it "stores the expected values for the passed in options while "\
           "ignoring unknown keys" do
          _(subject.attributes).must_equal(custom_attributes)
          _(subject.limit).must_equal(formatter_options.fetch(:limit))
          _(subject.class).must_equal(formatter_options.fetch(:class).to_s)
        end
      end
    end

    describe "#limit" do
      context "GIVEN no limit was set on initialization" do
        subject { unit_class.new }

        it "returns nil" do
          _(subject.limit).must_be_nil
        end

        context "GIVEN a block" do
          it "returns the result of the block" do
            _(subject.limit { "BLOCK_RESULT" }).must_equal("BLOCK_RESULT")
          end
        end
      end
    end

    describe "#class" do
      let(:class1) { [target_class, target_class.to_s].sample }
      let(:target_class) { CustomFormatter }

      context "GIVEN a constant or a String was set on initialization" do
        subject { unit_class.new(formatter_options: { class: class1 }) }

        it "returns the given value as a String" do
          _(subject.class).must_equal(target_class.to_s)
        end
      end

      context "GIVEN no class was set on initialization" do
        subject { unit_class.new }

        it "returns nil" do
          _(subject.class).must_be_nil
        end

        context "GIVEN a block" do
          it "returns the result of the block" do
            _(subject.class { target_class }).must_equal(target_class.to_s)
          end

          context "GIVEN a constant or a String result from the block" do
            it "returns the given value as a String" do
              _(subject.class { class1 }).must_equal(target_class.to_s)
            end
          end
        end
      end
    end
  end
end

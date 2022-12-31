# frozen_string_literal: true

require "test_helper"

module ObjectIdentifier
  class IdentifierTest < Minitest::Spec
    describe ObjectIdentifier::Identifier do
      describe "#identify" do
        context "GIVEN a single object" do
          it "returns attribute values" do
            subject = OpenStruct.new(name: "Pepper", beak_size: 4)
            value(subject.identify(:beak_size)).must_equal("OpenStruct[4]")
          end

          it "quotes Strings in attributes" do
            subject = OpenStruct.new(name: "Pepper")
            value(subject.identify(:name)).must_equal(%(OpenStruct["Pepper"]))
          end

          it "quotes symbols in attributes" do
            subject = OpenStruct.new(name: "Pepper", color: :grey)
            value(subject.identify(:color)).must_equal(%(OpenStruct[:"grey"]))
          end

          it "ignores attributes that don't exist" do
            subject = OpenStruct.new(name: "Pepper", color: :grey, beak_size: 4)
            value(subject.identify(:volume, :beak_size)).must_equal(
              "OpenStruct[4]")
          end

          it "returns the value of instance variables" do
            subject = OpenStruct.new
            subject.instance_variable_set(:@var1, 1)
            value(subject.identify(:@var1)).must_equal("OpenStruct[1]")
          end

          it "returns '[no objects]', GIVEN nil" do
            subject = nil
            value(subject.identify).must_equal("[no objects]")
          end

          context "GIVEN identifying more than a single attribute" do
            subject {
              OpenStruct.new(name: "Pepper", beak_size: 4, color: :grey)
            }

            it "returns including the attribute names" do
              subject.instance_variable_set(:@var1, 1)

              result = subject.identify(:name, :beak_size, :color, :@var1)

              expected_attributes_string =
                %(name:"Pepper", beak_size:4, color::"grey", @var1:1)
              value(result).must_equal(
                "OpenStruct[#{expected_attributes_string}]")
            end
          end

          context "GIVEN object responds to :id" do
            subject { OpenStruct.new(id: 1) }

            it "returns 'Class[<id value>]', GIVEN no other attributes" do
              value(subject.identify).must_equal("OpenStruct[1]")
            end
          end

          context "GIVEN object does not respond to :id" do
            subject { Object.new }

            it "returns '<ClassName>[]', GIVEN no attributes" do
              value(subject.identify).must_equal("Object[]")
            end
          end

          context "GIVEN a :klass" do
            subject { OpenStruct.new(id: 1) }

            it "overrides object class name" do
              value(subject.identify(klass: "Bird")).must_equal("Bird[1]")
            end

            it "returns no class, GIVEN :klass is nil" do
              value(subject.identify(klass: nil)).must_equal("[1]")
            end

            it "returns no class, GIVEN :klass is empty String" do
              value(subject.identify(klass: "")).must_equal("[1]")
            end
          end

          context "GIVEN a :limit" do
            subject { OpenStruct.new(id: 1) }

            it "ignores :limit" do
              value(subject.identify(:id, limit: 3)).must_equal("OpenStruct[1]")
            end
          end
        end

        context "GIVEN a collection of objects" do
          it "identifies each object in turn" do
            subject = [OpenStruct.new(id: 1), OpenStruct.new(id: 2)]
            value(subject.identify).must_equal("OpenStruct[1], OpenStruct[2]")
          end

          it "returns '[no objects]', GIVEN an empty Array" do
            subject = []
            value(subject.identify).must_equal("[no objects]")
          end

          it "returns '[no objects]', GIVEN an empty Hash" do
            subject = {}
            value(subject.identify).must_equal("[no objects]")
          end

          context "GIVEN a :klass" do
            subject { [OpenStruct.new(id: 1), Object.new] }

            it "overrides object class name for all objects" do
              value(subject.identify(klass: "Bird")).must_equal(
                "Bird[1], Bird[]")
            end

            it "returns no class, GIVEN :klass is nil" do
              value(subject.identify(klass: nil)).must_equal("[1], []")
            end

            it "returns no class, GIVEN :klass is empty String" do
              value(subject.identify(klass: "")).must_equal("[1], []")
            end
          end

          context "GIVEN a :limit" do
            subject { "abcdefg".chars }

            it "returns truncated list, GIVEN :limit" do
              value(subject.identify(:upcase, limit: 3)).must_equal(
                "String[\"A\"], "\
                "String[\"B\"], "\
                "String[\"C\"], ... (4 more)")
            end
          end
        end

        context "GIVEN a Struct (special case)" do
          subject { TestStruct.new(1) }

          it "returns the expected String" do
            value(subject.identify).must_equal(
              "ObjectIdentifier::IdentifierTest::TestStruct[1]")
          end

          TestStruct = Struct.new(:id) # rubocop:disable Lint/ConstantDefinitionInBlock
        end
      end
    end
  end
end

# frozen_string_literal: true

require "test_helper"

class ObjectIdentifier::Formatters::StringFormatterTest < Minitest::Spec
  describe ObjectIdentifier::Formatters::StringFormatter do
    let(:klazz) { ObjectIdentifier::Formatters::StringFormatter }

    describe ".call" do
      subject { klazz }

      context "GIVEN a single object" do
        it "quotes Strings in attributes" do
          object = OpenStruct.new(name: "Pepper")
          value(subject.call(object, :name)).must_equal(%(OpenStruct["Pepper"]))
        end

        it "quotes symbols in attributes" do
          object = OpenStruct.new(name: "Pepper", color: :grey)
          value(subject.call(object, :color)).must_equal(%(OpenStruct[:"grey"]))
        end

        it "ignores attributes that don't exist" do
          object = OpenStruct.new(name: "Pepper", color: :grey, beak_size: 4)
          value(subject.call(object, %i[volume beak_size])).
            must_equal("OpenStruct[4]")
        end

        it "returns the value of instance variables" do
          object = OpenStruct.new
          object.instance_variable_set(:@var1, 1)
          value(subject.call(object, :@var1)).must_equal("OpenStruct[1]")
        end

        it "returns '[no objects]', GIVEN object = nil" do
          value(subject.call(nil)).must_equal("[no objects]")
        end

        it "returns '[no objects]', GIVEN object = an empty Hash" do
          value(subject.call({})).must_equal("[no objects]")
        end

        it "returns '[no objects]', GIVEN object = an empty Array" do
          value(subject.call([])).must_equal("[no objects]")
        end

        it "doesn't return '[no objects]', "\
           "GIVEN object = an array of blank objects" do
          value(subject.call([[], {}, nil])).wont_equal("[no objects]")
        end

        context "GIVEN multiple attribute to identify" do
          it "includes all of the given attribute names/values" do
            object = OpenStruct.new(name: "Pepper", beak_size: 4, color: :grey)
            object.instance_variable_set(:@var1, 1)

            result = subject.call(object, %i[name beak_size color @var1])

            expected_attributes_string =
              %(name:"Pepper", beak_size:4, color::"grey", @var1:1)
            value(result).must_equal(
              "OpenStruct[#{expected_attributes_string}]")
          end
        end

        context "GIVEN object responds to :id" do
          it "returns 'Class[<id value>]', GIVEN no other attributes" do
            value(subject.call(OpenStruct.new(id: 1))).
              must_equal("OpenStruct[1]")
          end
        end

        context "GIVEN object does not respond to :id" do
          it "returns '<ClassName>[]', GIVEN no attributes" do
            value(subject.call(Object.new)).must_equal("Object[]")
          end
        end

        context "GIVEN a :klass" do
          let(:object) { OpenStruct.new(id: 1) }

          it "overrides object class name" do
            value(subject.call(object, klass: "Bird")).must_equal("Bird[1]")
          end

          it "returns no class, GIVEN :klass is nil" do
            value(subject.call(object, klass: nil)).must_equal("[1]")
          end

          it "returns no class, GIVEN :klass is empty String" do
            value(subject.call(object, klass: "")).must_equal("[1]")
          end
        end

        it "ignores :limit" do
          object = OpenStruct.new(id: 1)
          value(subject.call(object, :id, limit: 3)).must_equal("OpenStruct[1]")
        end
      end

      context "GIVEN a collection of objects" do
        let(:object) { [OpenStruct.new(id: 1), Object.new] }

        it "identifies each object in turn" do
          value(subject.call(object)).must_equal("OpenStruct[1], Object[]")
        end

        it "overrides object class name for all objects, GIVEN a :klass" do
          value(subject.call(object, klass: "Bird")).
            must_equal("Bird[1], Bird[]")
        end

        it "returns no class, GIVEN :klass is nil" do
          value(subject.call(object, klass: nil)).must_equal("[1], []")
        end

        it "returns no class, GIVEN :klass is empty String" do
          value(subject.call(object, klass: "")).must_equal("[1], []")
        end

        it "returns truncated list, GIVEN :limit" do
          object = "abcdefg".chars
          value(subject.call(object, :upcase, limit: 3)).must_equal(
            "String[\"A\"], "\
            "String[\"B\"], "\
            "String[\"C\"], ... (4 more)")
        end
      end

      context "GIVEN a Struct (special case)" do
        let(:object) { TestStruct.new(1) }

        it "returns the expected String" do
          value(subject.call(object)).must_equal(
            "ObjectIdentifier::Formatters::StringFormatterTest::TestStruct[1]")
        end

        TestStruct = Struct.new(:id) # rubocop:disable Lint/ConstantDefinitionInBlock
      end
    end
  end
end

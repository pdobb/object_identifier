# frozen_string_literal: true

require "test_helper"

class ObjectIdentifier::StringFormatterTest < Minitest::Spec
  # ObjectIdentifier::StringFormatterTest::TestStruct is a Test Dummy.
  TestStruct = Struct.new(:id)

  IdentifiableTestClass =
    Struct.new(:id, :name, :attr1, keyword_init: true) do
      # :reek:UncommunicativeParameterName
      def initialize(id: nil, name: nil, attr1: nil)
        super
      end
    end

  describe "ObjectIdentifier::StringFormatter" do
    let(:unit_class) { ObjectIdentifier::StringFormatter }

    describe ".call" do
      def parameterize(attributes = [], **formatter_options)
        {
          parameters:
            ObjectIdentifier::Parameters.build(
              attributes: attributes,
              formatter_options: formatter_options),
        }
      end

      subject { unit_class }

      context "GIVEN a single object" do
        it "quotes Strings in attributes" do
          object = IdentifiableTestClass.new(name: "TestName")
          _(subject.call(object, **parameterize(:name))).must_equal(
            %(#{IdentifiableTestClass}["TestName"]))
        end

        it "quotes symbols in attributes" do
          object = IdentifiableTestClass.new(name: "TestName", attr1: :value1)
          _(subject.call(object, **parameterize(:attr1))).must_equal(
            "#{IdentifiableTestClass}[:value1]")
        end

        it "ignores attributes that don't exist" do
          object = IdentifiableTestClass.new(name: "TestName", attr1: :value1)
          _(subject.call(object, **parameterize(%i[attr1 unknown_attr1])))
            .must_equal("#{IdentifiableTestClass}[:value1]")
        end

        it "returns the value of instance variables" do
          object = IdentifiableTestClass.new
          object.instance_variable_set(:@var1, 1)
          _(subject.call(object, **parameterize(:@var1))).must_equal(
            "#{IdentifiableTestClass}[1]")
        end

        it "returns '[no objects]', GIVEN object = nil" do
          _(subject.call(nil)).must_equal("[no objects]")
        end

        it "returns '[no objects]', GIVEN object = an empty Hash" do
          _(subject.call({})).must_equal("[no objects]")
        end

        it "returns '[no objects]', GIVEN object = an empty Array" do
          _(subject.call([])).must_equal("[no objects]")
        end

        it "doesn't return '[no objects]', "\
           "GIVEN object = an array of blank objects" do
          _(subject.call([[], {}, nil])).wont_equal("[no objects]")
        end

        context "GIVEN multiple attribute to identify" do
          it "includes all of the given attribute names/values" do
            object = IdentifiableTestClass.new(name: "TestName", attr1: :value1)
            object.instance_variable_set(:@var1, 1)

            result =
              subject.call(
                object, **parameterize(%i[name attr1 @var1]))

            expected_attributes_string =
              %(name:"TestName", attr1::value1, @var1:1)
            _(result).must_equal(
              "#{IdentifiableTestClass}[#{expected_attributes_string}]")
          end
        end

        context "GIVEN object responds to :id" do
          it "returns 'Class[<id value>]', GIVEN no other attributes" do
            _(subject.call(IdentifiableTestClass.new(id: 1))).must_equal(
              "#{IdentifiableTestClass}[1]")
          end
        end

        context "GIVEN object does not respond to :id" do
          it "returns '<ClassName>[]', GIVEN no attributes" do
            _(subject.call(Object.new)).must_equal("Object[]")
          end
        end

        context "GIVEN a :class" do
          let(:object) { IdentifiableTestClass.new(id: 1) }

          it "overrides object class name" do
            _(subject.call(object, **parameterize(class: "MyClass")))
              .must_equal("MyClass[1]")
          end

          it "returns no class name, GIVEN :class is blank" do
            _(subject.call(object, **parameterize(class: [nil, ""].sample)))
              .must_equal("[1]")
          end
        end

        it "ignores :limit" do
          object = IdentifiableTestClass.new(id: 1)
          _(subject.call(object, **parameterize(:id, limit: 3)))
            .must_equal("#{IdentifiableTestClass}[1]")
        end
      end

      context "GIVEN a collection of objects" do
        let(:object) { [IdentifiableTestClass.new(id: 1), Object.new] }

        it "identifies each object in turn" do
          _(subject.call(object)).must_equal(
            "#{IdentifiableTestClass}[1], Object[]")
        end

        it "overrides object class name for all objects, GIVEN a :class" do
          _(subject.call(object, **parameterize(class: "MyClass")))
            .must_equal("MyClass[1], MyClass[]")
        end

        it "returns no class name, GIVEN :class is blank" do
          _(subject.call(object, **parameterize(class: [nil, ""].sample)))
            .must_equal("[1], []")
        end

        it "returns truncated list, GIVEN :limit" do
          object = "abcdefg".chars
          _(subject.call(object, **parameterize(:upcase, limit: 3)))
            .must_equal(
              "String[\"A\"], "\
              "String[\"B\"], "\
              "String[\"C\"], ... (4 more)")
        end
      end

      context "GIVEN a Struct (special case)" do
        let(:object) { TestStruct.new(1) }

        it "returns the expected String" do
          _(subject.call(object)).must_equal(
            "ObjectIdentifier::StringFormatterTest::TestStruct[1]")
        end
      end
    end
  end
end

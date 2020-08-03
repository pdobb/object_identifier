# frozen_string_literal: true

require "test_helper"

module ObjectIdentifier
  class IdentifierTest < Minitest::Spec
    describe ObjectIdentifier::Identifier do
      describe "#identify" do
        context "GIVEN a single object" do
          it "returns attribute values" do
            subject = OpenStruct.new(name: "Pepper", beak_size: 4)
            subject.identify(:beak_size).must_equal "OpenStruct[4]"
          end

          it "quotes Strings in attributes" do
            subject = OpenStruct.new(name: "Pepper")
            subject.identify(:name).must_equal %(OpenStruct["Pepper"])
          end

          it "quotes symbols in attributes" do
            subject = OpenStruct.new(name: "Pepper", color: :grey)
            subject.identify(:color).must_equal %(OpenStruct[:"grey"])
          end

          it "ignores attributes that don't exist" do
            subject = OpenStruct.new(name: "Pepper", color: :grey, beak_size: 4)
            subject.identify(:volume, :beak_size).
              must_equal "OpenStruct[4]"
          end

          it "returns the value of instance variables" do
            subject = OpenStruct.new
            subject.instance_variable_set(:@var1, 1)
            subject.identify(:@var1).must_equal "OpenStruct[1]"
          end

          it "returns '[no objects]', GIVEN nil" do
            subject = nil
            subject.identify.must_equal "[no objects]"
          end

          context "GIVEN identifying more than a single attribute" do
            it "returns including the attribute names" do
              subject =
                OpenStruct.new(name: "Pepper", beak_size: 4, color: :grey)
              subject.instance_variable_set(:@var1, 1)

              subject.identify(:name, :beak_size, :color, :@var1).must_equal(
                %(OpenStruct[name:"Pepper", beak_size:4, color::"grey", @var1:1]))
            end
          end

          context "GIVEN object responds to :id" do
            subject { OpenStruct.new(id: 1) }

            it "returns 'Class[<id value>]', GIVEN no other attributes" do
              subject.identify.must_equal "OpenStruct[1]"
            end
          end

          context "GIVEN object does not respond to :id" do
            subject { Object.new }

            it "returns '<ClassName>[]', GIVEN no attributes" do
              subject.identify.must_equal "Object[]"
            end
          end

          context "GIVEN a :klass" do
            subject { OpenStruct.new(id: 1) }

            it "overrides object class name" do
              subject.identify(klass: "Bird").must_equal "Bird[1]"
            end

            it "returns no class, GIVEN :klass is nil" do
              subject.identify(klass: nil).must_equal "[1]"
            end

            it "returns no class, GIVEN :klass is empty String" do
              subject.identify(klass: "").must_equal "[1]"
            end
          end

          context "GIVEN a :limit" do
            subject { OpenStruct.new(id: 1) }

            it "ignores :limit" do
              subject.identify(:id, limit: 3).must_equal "OpenStruct[1]"
            end
          end
        end

        context "GIVEN a collection of objects" do
          it "identifies each object in turn" do
            subject = [OpenStruct.new(id: 1), OpenStruct.new(id: 2)]
            subject.identify.must_equal "OpenStruct[1], OpenStruct[2]"
          end

          it "returns '[no objects]', GIVEN an empty Array" do
            subject = []
            subject.identify.must_equal "[no objects]"
          end

          it "returns '[no objects]', GIVEN an empty Hash" do
            subject = {}
            subject.identify.must_equal "[no objects]"
          end

          context "GIVEN a :klass" do
            subject { [OpenStruct.new(id: 1), Object.new] }

            it "overrides object class name for all objects" do
              subject.identify(klass: "Bird").must_equal "Bird[1], Bird[]"
            end

            it "returns no class, GIVEN :klass is nil" do
              subject.identify(klass: nil).must_equal "[1], []"
            end

            it "returns no class, GIVEN :klass is empty String" do
              subject.identify(klass: "").must_equal "[1], []"
            end
          end

          context "GIVEN a :limit" do
            it "returns truncated list, GIVEN :limit" do
              subject = "abcdefg".chars
              subject.identify(:upcase, limit: 3).must_equal(
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

          TestStruct = Struct.new(:id)
        end
      end
    end
  end
end

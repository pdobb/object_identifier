require "test_helper"

class ObjectIdentifier::IdentifierTest < Minitest::Spec
  describe ObjectIdentifier::Identifier do
    describe "#identify" do
      context "GIVEN a single object" do
        it "returns attribute values" do
          subject = OpenStruct.new(name: "Pepper", beak_size: 4)
          subject.identify(:beak_size).must_equal "OpenStruct[beak_size:4]"
        end

        it "quotes strings in attributes" do
          subject = OpenStruct.new(name: "Pepper")
          subject.identify(:name).must_equal %(OpenStruct[name:"Pepper"])
        end

        it "quotes symbols in attributes" do
          subject = OpenStruct.new(name: "Pepper", color: :grey)
          subject.identify(:color).must_equal %(OpenStruct[color::"grey"])
        end

        it "ignores attributes that don't exist" do
          subject = OpenStruct.new(name: "Pepper", color: :grey, beak_size: 4)
          subject.identify(:volume, :beak_size).
            must_equal "OpenStruct[beak_size:4]"
        end

        it "returns '[no objects]', GIVEN nil" do
          subject = nil
          subject.identify.must_equal "[no objects]"
        end

        context "GIVEN object responds to :id" do
          subject { OpenStruct.new(id: 1) }

          it "returns 'Class[id:1]', GIVEN no other attributes" do
            subject.identify.must_equal "OpenStruct[id:1]"
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
            subject.identify(klass: "Bird").must_equal "Bird[id:1]"
          end

          it "returns no class, GIVEN :klass is nil" do
            subject.identify(klass: nil).must_equal "[id:1]"
          end

          it "returns no class, GIVEN :klass is empty string" do
            subject.identify(klass: "").must_equal "[id:1]"
          end
        end

        context "GIVEN a :limit" do
          subject { OpenStruct.new(id: 1) }

          it "ignores :limit" do
            subject.identify(:id, limit: 3).must_equal "OpenStruct[id:1]"
          end
        end
      end

      context "GIVEN a collection of objects" do
        it "identifies each object in turn" do
          subject = [OpenStruct.new(id: 1), OpenStruct.new(id: 2)]
          subject.identify.must_equal "OpenStruct[id:1], OpenStruct[id:2]"
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
            subject.identify(klass: "Bird").must_equal "Bird[id:1], Bird[]"
          end

          it "returns no class, GIVEN :klass is nil" do
            subject.identify(klass: nil).must_equal "[id:1], []"
          end

          it "returns no class, GIVEN :klass is empty string" do
            subject.identify(klass: "").must_equal "[id:1], []"
          end
        end

        context "GIVEN a :limit" do
          it "returns truncated list, GIVEN :limit" do
            subject = "abcdefg".chars
            subject.identify(:upcase, limit: 3).must_equal(
              "String[upcase:\"A\"], String[upcase:\"B\"], String[upcase:\"C\"], ... (4 more)")
          end
        end
      end
    end
  end
end

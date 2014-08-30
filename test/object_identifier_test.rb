require "test_helper"

describe ObjectIdentifier::Identifier do
  describe "#identify" do
    it "yields 'Class[id:1]', GIVEN id and no attributes" do
      OpenStruct.new(id: 1).identify.must_equal "OpenStruct[id:1]"
    end

    it "lists each entry in collection" do
      collection = [OpenStruct.new(id: 1), OpenStruct.new(id: 2)]
      collection.identify.must_equal "OpenStruct[id:1], OpenStruct[id:2]"
    end

    describe "no attributes, no id, empty array, nil" do
      it "yields 'Class[]', GIVEN no id or attributes" do
        Object.new.identify.must_equal "Object[]"
      end

      it "yields '[no objects]', GIVEN an empty array" do
        [].identify.must_equal "[no objects]"
      end

      it "yields '[no objects]', GIVEN nil" do
        nil.identify.must_equal "[no objects]"
      end
    end

    describe "with attributes" do
      it "yields attribute values" do
        obj = OpenStruct.new(name: "Pepper", beak_size: 4)
        obj.identify(:beak_size).must_equal "OpenStruct[beak_size:4]"
      end

      it "quotes strings" do
        obj = OpenStruct.new(name: "Pepper")
        obj.identify(:name).must_equal %(OpenStruct[name:"Pepper"])
      end

      it "quotes symbols" do
        obj = OpenStruct.new(name: "Pepper", color: :grey)
        obj.identify(:color).must_equal %(OpenStruct[color::"grey"])
      end

      it "ignores attributes that don't exist" do
        obj = OpenStruct.new(name: "Pepper", color: :grey, beak_size: 4)
        obj.identify(:volume, :beak_size).must_equal "OpenStruct[beak_size:4]"
      end
    end

    describe "options" do
      it "overrides object class name with :klass" do
        OpenStruct.new(id: 1).identify(klass: "Monkey").must_equal "Monkey[id:1]"
      end

      it "yields no class, GIVEN class is empty string" do
        OpenStruct.new(id: 1).identify(klass: "").must_equal "[id:1]"
        OpenStruct.new(id: 1).identify(klass: nil).must_equal "[id:1]"
      end

      it "overrides object class name with :klass with no attributes" do
        [].identify(klass: "Monkey").must_equal "Monkey[]"
      end

      it "yields first n (:limit) objects in collection" do
        (1..7).to_a.identify(:to_i, limit: 3).must_equal(
          "Fixnum[to_i:1], Fixnum[to_i:2], Fixnum[to_i:3], ... (4 more)")
      end
    end
  end
end

require "test_helper"

describe ObjectIdentifier::Identifier do
  describe "#identify" do
    it "yields 'Class[id:1]' when id and no attributes" do
      assert OpenStruct.new(id: 1).identify == "OpenStruct[id:1]"
    end

    it "lists each entry in collection" do
      collection = [OpenStruct.new(id: 1), OpenStruct.new(id: 2)]
      assert collection.identify == "OpenStruct[id:1], OpenStruct[id:2]"
    end

    describe "no attributes, no id, empty array, nil" do
      it "yields 'Class[]' when no id or attributes" do
        assert Object.new.identify == "Object[]"
      end

      it "yields '[no objects]' when an empty array" do
        assert [].identify == "[no objects]"
      end

      it "yields '[no objects]' when nil" do
        assert nil.identify == "[no objects]"
      end
    end

    describe "with attributes" do
      it "yields attribute values" do
        obj = OpenStruct.new(name: "Pepper", beak_size: 4)
        assert obj.identify(:beak_size) == "OpenStruct[beak_size:4]"
      end

      it "quotes strings" do
        obj = OpenStruct.new(name: "Pepper")
        assert obj.identify(:name) == %(OpenStruct[name:"Pepper"])
      end

      it "quotes symbols" do
        obj = OpenStruct.new(name: "Pepper", color: :grey)
        assert obj.identify(:color) == %(OpenStruct[color::"grey"])
      end

      it "ignores attributes that don't exist" do
        obj = OpenStruct.new(name: "Pepper", color: :grey, beak_size: 4)
        assert obj.identify(:volume, :beak_size) == "OpenStruct[beak_size:4]"
      end
    end

    describe "options" do
      it "overrides object class name with :klass" do
        assert OpenStruct.new(id: 1).identify(klass: "Monkey") == "Monkey[id:1]"
      end

      it "yields no class if given class is empty string" do
        assert OpenStruct.new(id: 1).identify(klass: "") == "[id:1]"
        assert OpenStruct.new(id: 1).identify(klass: nil) == "[id:1]"
      end

      it "overrides object class name with :klass with no attributes" do
        assert [].identify(klass: "Monkey") == "Monkey[]"
      end

      it "yields first n (:limit) objects in collection" do
        assert [1,2,3,4,5,6,7].identify(:to_i, limit: 3) ==
          "Fixnum[to_i:1], Fixnum[to_i:2], Fixnum[to_i:3], ... (4 more)"
      end
    end
  end
end

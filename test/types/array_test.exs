defmodule Dry.Types.ArrayTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Array.options(default: :array, optional: true) == %Types.Array{
               optional: true,
               default: :array
             }

      assert Types.Array.options(default: :array) == %Types.Array{default: :array}
      assert Types.Array.options(type: Types.Array) == %Types.Array{type: Types.Array}
      assert Types.Array.options(invalid: :array) == %Types.Array{}
      assert Types.Array.options() == %Types.Array{}
    end
  end

  describe "#valid?" do
    context "when value is array" do
      it "returns true" do
        assert Types.Array.valid?([]) == true
        assert Types.Array.valid?([1, "a", 5.5]) == true
      end
    end

    context "when value is not a array" do
      it "returns false" do
        assert Types.Array.valid?(5) == false
      end
    end
  end

  describe "#valid_list?" do
    context "when all elements in a list are valid" do
      it "returns true" do
        assert Types.Array.valid_list?(Types.String, ["bob", "mark"]) == true
      end
    end

    context "when one of the elements in a list is invalid" do
      it "returns the correct error" do
        assert Types.Array.valid_list?(Types.String, ["bob", 1, "mark"]) == {:error, 1}
      end
    end

    context "when the value is not an array" do
      it "returns false" do
        assert Types.Array.valid_list?(Types.String, "string") == false
      end
    end
  end
end

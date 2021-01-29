defmodule Dry.Types.StructTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Struct.options(default: :struct, optional: true) == %Types.Struct{
               optional: true,
               default: :struct
             }

      assert Types.Struct.options(default: :struct) == %Types.Struct{default: :struct}
      assert Types.Struct.options(type: Types.Struct) == %Types.Struct{type: Types.Struct}
      assert Types.Struct.options(invalid: :struct) == %Types.Struct{}
      assert Types.Struct.options() == %Types.Struct{}
    end
  end

  describe "#valid?" do
    context "when value is struct" do
      it "returns true" do
        assert Types.Struct.valid?(%Dry.ExampleStruct{}) == true
      end
    end

    context "when value is not a struct" do
      it "returns false" do
        assert Types.Struct.valid?(5) == false
      end
    end
  end
end

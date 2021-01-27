defmodule Dry.Types.FloatTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Float.options(default: 15.5, optional: true) == %Types.Float{
               optional: true,
               default: 15.5
             }

      assert Types.Float.options(default: 15.5) == %Types.Float{default: 15.5}
      assert Types.Float.options(invalid: 15.5) == %Types.Float{}
      assert Types.Float.options() == %Types.Float{}
    end
  end

  describe "#valid?" do
    context "when value is float" do
      it "returns true" do
        assert Types.Float.valid?(5.5) == true
      end
    end

    context "when value is not a float" do
      it "returns false" do
        assert Types.Float.valid?(5) == false
      end
    end
  end
end

defmodule Dry.Types.AnyTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Any.options(default: 10, optional: true) == %Types.Any{
               optional: true,
               default: 10
             }

      assert Types.Any.options(default: 10) == %Types.Any{default: 10}
      assert Types.Any.options(invalid: 10) == %Types.Any{}
      assert Types.Any.options() == %Types.Any{}
    end
  end

  describe "#valid?" do
    it "always returns true" do
      assert Types.Any.valid?(5) == true
      assert Types.Any.valid?("string") == true
    end
  end
end

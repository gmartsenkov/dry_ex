defmodule Dry.Types.ArrayTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Array.options(default: :array, optional: true) == %Types.Array{optional: true, default: :array}
      assert Types.Array.options(default: :array) == %Types.Array{default: :array}
      assert Types.Array.options(of: Types.String) == %Types.Array{of: Types.String}
      assert Types.Array.options(invalid: :array) == %Types.Array{}
      assert Types.Array.options() == %Types.Array{}
    end
  end
end

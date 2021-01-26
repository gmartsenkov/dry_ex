defmodule Dry.Types.IntegerTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Integer.options(default: 10, optional: true) == %Types.Integer{optional: true, default: 10}
      assert Types.Integer.options(default: 10) == %Types.Integer{default: 10}
      assert Types.Integer.options(invalid: 10) == %Types.Integer{}
      assert Types.Integer.options() == %Types.Integer{}
    end
  end
end

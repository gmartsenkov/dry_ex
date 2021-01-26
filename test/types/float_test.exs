defmodule Dry.Types.FloatTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Float.options(default: 15.5, optional: true) == %Types.Float{optional: true, default: 15.5}
      assert Types.Float.options(default: 15.5) == %Types.Float{default: 15.5}
      assert Types.Float.options(invalid: 15.5) == %Types.Float{}
      assert Types.Float.options() == %Types.Float{}
    end
  end
end

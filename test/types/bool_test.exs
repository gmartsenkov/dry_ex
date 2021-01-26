defmodule Dry.Types.BoolTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Bool.options(default: true, optional: true) == %Types.Bool{optional: true, default: true}
      assert Types.Bool.options(default: true) == %Types.Bool{default: true}
      assert Types.Bool.options(invalid: true) == %Types.Bool{}
      assert Types.Bool.options() == %Types.Bool{}
    end
  end
end

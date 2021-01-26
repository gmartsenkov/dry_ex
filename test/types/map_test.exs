defmodule Dry.Types.MapTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Map.options(default: %{a: 1}, optional: true) == %Types.Map{optional: true, default: %{a: 1}}
      assert Types.Map.options(default: %{a: 1}) == %Types.Map{default: %{a: 1}}
      assert Types.Map.options(invalid: %{a: 1}) == %Types.Map{}
      assert Types.Map.options() == %Types.Map{}
    end
  end
end

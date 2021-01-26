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

  describe "#valid?" do
    context "when value is map" do
      it "returns true" do
        assert Types.Map.valid?(%{key: true}) == true
      end
    end

    context "when value is not a map" do
      it "returns false" do
        assert Types.Map.valid?(5) == false
      end
    end
  end
end

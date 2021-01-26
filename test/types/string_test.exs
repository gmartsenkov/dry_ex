defmodule Dry.Types.StringTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.String.options(default: "str", optional: true) == %Types.String{optional: true, default: "str"}
      assert Types.String.options(default: "str") == %Types.String{default: "str"}
      assert Types.String.options(invalid: "str") == %Types.String{}
      assert Types.String.options() == %Types.String{}
    end
  end

  describe "#valid?" do
    context "when value is string" do
      it "returns true" do
        assert Types.String.valid?("bob") == true
      end
    end

    context "when value is not a string" do
      it "returns false" do
        assert Types.String.valid?(5) == false
      end
    end
  end
end

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
end

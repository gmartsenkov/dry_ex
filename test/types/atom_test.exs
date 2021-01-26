defmodule Dry.Types.AtomTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Atom.options(default: :atom, optional: true) == %Types.Atom{optional: true, default: :atom}
      assert Types.Atom.options(default: :atom) == %Types.Atom{default: :atom}
      assert Types.Atom.options(invalid: :atom) == %Types.Atom{}
      assert Types.Atom.options() == %Types.Atom{}
    end
  end
end

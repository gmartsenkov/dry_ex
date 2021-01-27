defmodule Dry.Types.AtomTest do
  use ExSpec

  alias Dry.Types

  describe "#options" do
    it "returns the correct struct" do
      assert Types.Atom.options(default: :atom, optional: true) == %Types.Atom{
               optional: true,
               default: :atom
             }

      assert Types.Atom.options(default: :atom) == %Types.Atom{default: :atom}
      assert Types.Atom.options(invalid: :atom) == %Types.Atom{}
      assert Types.Atom.options() == %Types.Atom{}
    end
  end

  describe "#valid?" do
    context "when value is atom" do
      it "returns true" do
        assert Types.Atom.valid?(:bob) == true
      end
    end

    context "when value is not an atom" do
      it "returns false" do
        assert Types.Atom.valid?(5) == false
      end
    end
  end
end

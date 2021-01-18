defmodule DryTest do
  use ExSpec, async: true

  doctest Dry

  defmodule Test do
    use Dry

    schema do
      attribute(:name, :string)
      attribute(:age, :integer, optional: true)
      attribute(:height)
      attribute(:country, :string, default: "UK")

      attribute :is_adult do
        Map.get(entity, :age, 0) >= 18
      end

      attribute :tall do
        Map.get(entity, :height, 0) > 180
      end
    end
  end

  describe "#new!" do
    it "generates the correct struct" do
      assert Test.new!(%{name: "Rob", age: 18, height: 169, country: "BG"}) == %Test{
               name: "Rob",
               age: 18,
               height: 169,
               is_adult: true,
               tall: false,
               country: "BG"
             }
    end

    it "works when a default is set" do
      assert Test.new!(%{name: "Bob", age: 5, height: 190}) == %Test{
               name: "Bob",
               age: 5,
               height: 190,
               is_adult: false,
               country: "UK",
               tall: true
             }
    end

    context "when non-optional attribute is missing" do
      it "raises an exception" do
        assert_raise Dry.RuntimeError,
                     "[Elixir.DryTest.Test] - Required attribute :name is missing",
                     fn ->
                       Test.new!(%{})
                     end
      end
    end

    context "when optional attribute is missing" do
      it "returns the correct struct" do
        assert Test.new!(%{name: "Bob", height: 190}) == %Test{
                 name: "Bob",
                 age: nil,
                 height: 190,
                 is_adult: false,
                 country: "UK",
                 tall: true
               }
      end
    end
  end

  describe "#new" do
    context "when no error occurs" do
      it "returns an ok tuple" do
        {:ok, result} = Test.new(%{name: "Rob", age: 18, height: 169, country: "BG"})

        assert result == %Test{
                 name: "Rob",
                 age: 18,
                 height: 169,
                 is_adult: true,
                 tall: false,
                 country: "BG"
               }
      end
    end

    context "when an error occurs" do
      it "returns an error tuple" do
        {:error, error} = Test.new(%{})
        assert error == "[Elixir.DryTest.Test] - Required attribute :name is missing"
      end
    end
  end
end

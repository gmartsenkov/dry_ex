defmodule DryTest do
  use ExSpec

  doctest Dry

  defmodule Test do
    use Dry

    schema do
      attribute(:name, :string)
      attribute(:age)
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

  describe "#new" do
    it "generates the correct struct" do
      assert Test.new!(%{name: "Bob", age: 5, height: 190}) == %Test{
               name: "Bob",
               age: 5,
               height: 190,
               is_adult: false,
               country: "UK",
               tall: true
             }

      assert Test.new!(%{name: "Rob", age: 18, height: 169, country: "BG"}) == %Test{
               name: "Rob",
               age: 18,
               height: 169,
               is_adult: true,
               tall: false,
               country: "BG"
             }

      assert_raise Dry.Error, "Required attribute :name is missing", fn ->
        Test.new!(%{})
      end
    end
  end
end

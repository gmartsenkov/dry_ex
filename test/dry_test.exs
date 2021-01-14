defmodule DryTest do
  use ExSpec

  doctest Dry

  defmodule Test do
    use Dry

    schema do
      attribute(:name, :string)
      attribute(:age)
      attribute(:height)

      attribute :is_adult do
        entity.age >= 18
      end

      attribute :tall do
        entity.height > 180
      end
    end
  end

  describe "#new" do
    it "generates the correct struct" do
      assert Test.new(%{name: "Bob", age: 5, height: 190}) == %Test{
               name: "Bob",
               age: 5,
               height: 190,
               is_adult: false,
               tall: true
             }

      assert Test.new(%{name: "Rob", age: 18, height: 169}) == %Test{
               name: "Rob",
               age: 18,
               height: 169,
               is_adult: true,
               tall: false
             }
    end
  end
end

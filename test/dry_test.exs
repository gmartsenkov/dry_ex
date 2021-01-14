defmodule DryTest do
  use ExUnit.Case
  doctest Dry

  defmodule Test do
    use Dry

    schema do
      attribute :name, :string
      attribute :age
      attribute :height
      attribute :is_adult do
        entity.age > 18
      end
      attribute :tall do
        entity.height > 180
      end
    end
  end

  test "attributes" do
    struct = Test.new(%{name: "Bob", age: 5, height: 190})

    assert struct.name == "Bob"
    assert struct.age == 5
    assert struct.is_adult == false
    assert struct.height == 190
    assert struct.tall == true
  end
end

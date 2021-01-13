defmodule DryTest do
  use ExUnit.Case
  doctest Dry

  defmodule Test do
    use Dry

    schema do
      attribute :name, :string
      attribute :age, Float
    end
  end

  test "attributes" do
    struct = Test.new(%{name: "Bob", age: 5})

    assert struct.name == "Bob"
    assert struct.age == 5
  end
end

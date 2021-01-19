# Dry

Dry tries to provide a nice DSL for building complex data structures, without having to do custom mappings and validation. It's highly inspired by Ruby's `dry-struct` library.

## Usage

```elixir
defmodule Sibling do
  use Dry

  schema do
    attribute(:name, :string)
  end
end

defmodule User do
  use Dry

  schema do
    attribute(:name, :string)
    attribute(:age, :integer, optional: true)
    attribute(:height)
    attribute(:country, :string, default: "UK")
    attribute(:siblings, array_of: Sibling)
    attribute(:favourite_colours, array_of: :string, default: ["blue", "green"])

    attribute :is_adult do
      Map.get(entity, :age, 0) >= 18
    end

    attribute :tall do
      Map.get(entity, :height, 0) >= 180
    end
  end
end

user = User.new!(%{name: "Rob", age: 18, height: 169, country: "BG", siblings: [%{name: "John"}]})
user == %User{
  age: 18,
  country: "BG",
  height: 169,
  is_adult: true,
  name: "Rob",
  tall: false,
  siblings: [%Sibling{name: "John"}],
  favourite_colours: ["blue", "green"]
}
{:ok, _user} = User.new(%{name: "Rob", age: 18, height: 169, country: "BG", siblings: [%{name: "John"}]})
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dry` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dry,  0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dry](https://hexdocs.pm/dry).


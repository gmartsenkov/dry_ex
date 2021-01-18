defmodule Dry do
  @moduledoc """
  Allow for creating structs, with fields of certain type, default value, custom function and more.
  ## Example:
  ```
  iex> defmodule User do
  ...>   use Dry
  ...>
  ...>   schema do
  ...>     attribute(:name, :string)
  ...>     attribute(:age, :integer, optional: true)
  ...>     attribute(:height)
  ...>     attribute(:country, :string, default: "UK")
  ...>
  ...>     attribute :is_adult do
  ...>       Map.get(entity, :age, 0) >= 18
  ...>     end
  ...>
  ...>     attribute :tall do
  ...>       Map.get(entity, :height, 0) > 180
  ...>     end
  ...>   end
  ...> end
  ...> _user = User.new!(%{name: "Rob", age: 18, height: 169, country: "BG"})
  ...># %User{
  ...>#   age: 18,
  ...>#   country: "BG",
  ...>#   height: 169,
  ...>#   is_adult: true,
  ...>#   name: "Rob",
  ...>#   tall: false
  ...># }
  ...> {:ok, _user} = User.new(%{name: "Rob", age: 18, height: 169, country: "BG"})
  ```
  """

  defmacro __using__(_) do
    quote do
      import Dry, only: [schema: 1]

      Module.register_attribute(__MODULE__, :attributes, accumulate: true)
    end
  end

  defmacro schema(do: block) do
    prelude =
      quote do
        try do
          import Dry

          unquote(block)
        after
          :ok
        end
      end

    postlude =
      quote unquote: false do
        @attributes
        |> Enum.map(fn attr -> Enum.at(attr, 0) end)
        |> Kernel.defstruct()

        def __attributes__(), do: @attributes

        def new!(attr) do
          processed =
            __attributes__()
            |> Enum.reverse()
            |> Enum.map(fn a -> Dry.Processor.process(a, attr, __MODULE__) end)
            |> Enum.into(%{})

          struct(__MODULE__, processed)
        end

        def new(attr) do
          try do
            {:ok, new!(attr)}
          rescue
            e in Dry.RuntimeError -> {:error, e.message}
          end
        end
      end

    quote do
      unquote(prelude)
      unquote(postlude)
    end
  end

  defmacro attribute(name, do: block) do
    quote do
      attribute = [unquote(name), :__func__]

      def unquote(name)(e) do
        Kernel.var!(entity) = e
        unquote(block)
      end

      Module.put_attribute(__MODULE__, :attributes, attribute)
    end
  end

  defmacro attribute(name, type \\ nil, opts \\ []) do
    quote do
      attribute = [unquote(name), unquote(type), unquote(opts)]
      Module.put_attribute(__MODULE__, :attributes, attribute)
    end
  end
end

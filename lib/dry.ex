defmodule Dry do
  @moduledoc """
  Allow for creating structs, with fields of certain type, default value, custom function and more.
  ## Example:
  ```elixir
  defmodule Sibling do
    use Dry
    alias Dry.Types

    schema do
      attribute(:name, Types.String)
    end
  end

  defmodule User do
    use Dry
    alias Dry.Types

    schema do
        attribute(:name, Types.String)
        attribute(:age, Types.Integer.options(optional: true))
        attribute(:height)
        attribute(:country, Types.String.options(default: "UK"))
        attribute(:siblings, Types.Array.options(type: Sibling))
        attribute(:favourite_colours, Types.Array.options(type: Types.String, default: ["blue", "green"]))

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
  {:ok, _user} = User.new(%{name: "Rob", age: 18, height: 169, country: "BG", siblings: [%{name: "John"}]})  ```
  """

  defmacro __using__(_) do
    quote do
      import Dry, only: [schema: 1]

      Module.register_attribute(__MODULE__, :attributes, accumulate: true)
    end
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
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

        def new!(attr) when is_list(attr) do
          attr
          |> Enum.into(%{})
          |> new!()
        end

        def new!(attr) when is_map(attr) do
          attr =
            __attributes__()
            |> Enum.reverse()
            |> Enum.reject(&Dry.Processor.function?/1)
            |> Enum.map(fn a -> Dry.Processor.process(a, attr, __MODULE__) end)
            |> Enum.into(%{})

          processed =
            __attributes__()
            |> Enum.reverse()
            |> Enum.filter(&Dry.Processor.function?/1)
            |> Enum.map(fn a -> Dry.Processor.process(a, attr, __MODULE__) end)
            |> Enum.into(attr)

          struct(__MODULE__, processed)
        end

        def new(attr) do
          try do
            {:ok, new!(attr)}
          rescue
            e in Dry.RuntimeError -> {:error, e.message}
          end
        end

        def valid?(%{__struct__: __MODULE__} = value) when is_struct(value), do: true
        def valid?(_value), do: false

        def options(opts \\ []) do
          opts
          |> Keyword.put(:type, __MODULE__)
          |> Dry.Types.Struct.options()
        end

        @doc "Used to recognise Dry modules"
        def __dry__(), do: true
      end

    quote do
      unquote(prelude)
      unquote(postlude)
    end
  end

  defmacro attribute(name) do
    quote do
      attribute(unquote(name), nil)
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

  defmacro attribute(name, type) do
    quote do
      Module.put_attribute(__MODULE__, :attributes, [unquote(name), unquote(type)])
    end
  end

  defmacro attribute?(name) do
    quote do
      attribute(unquote(name), nil)
    end
  end

  defmacro attribute?(name, type) do
    quote do
      Module.put_attribute(__MODULE__, :attributes, [unquote(name), unquote(type), :optional])
    end
  end

  @doc """
  Macro to define attribute withing a Dry schema
  Examples:
  ```
  attribute(:age, :integer, optional: true)
  ```
  Valid types can be - :atom, :string, :integer, :float, :bool, :map, :atom or a struct
  """
  defmacro attribute(name, type, opts) do
    quote do
      attribute = [unquote(name), unquote(type), unquote(opts)]
      Module.put_attribute(__MODULE__, :attributes, attribute)
    end
  end

  def map_to(nil, _struct), do: nil

  def map_to(value, struct) when is_list(value) do
    Enum.map(value, fn v -> struct.new!(v) end)
  end

  def map_to(value, struct) do
    struct.new!(value)
  end
end

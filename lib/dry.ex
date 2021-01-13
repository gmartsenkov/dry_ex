defmodule Dry do
  @moduledoc """
  """

  defmacro __using__(_) do
    quote do
      import Dry, only: [schema: 1]

      Module.register_attribute(__MODULE__, :attributes, accumulate: true)
    end
  end

  defmacro schema([do: block]) do
    prelude = quote do
      try do
        import Dry
        unquote(block)
      after
        :ok
      end
    end

    postlude = quote unquote: false do
      defstruct @attributes

      def new(attr) do
        struct(__MODULE__, attr)
      end
    end

    quote do
	    unquote(prelude)
	    unquote(postlude)
    end
  end

  defmacro attribute(name, _type) do
    quote do
      Module.put_attribute(__MODULE__, :attributes, unquote(name))
    end
  end
end

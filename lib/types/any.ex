defmodule Dry.Types.Any do
  @moduledoc """
  Represents any type

  ## Examples:
  ```elixir
  schema do
    attribute :field_1, Types.Any
    attribute :field_2, Types.Any.options(optional: true)
    attribute :field_3, Types.Any.options(default: "anything")
  end
  ```
  """

  defstruct [:default, :optional]

  @doc "Valid options are :default and :optional"
  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(_value), do: true
end

defmodule Dry.Types.Map do
  @moduledoc """
  Represents the map type

  ## Examples:
  ```elixir
  schema do
    ttribute :field_1, Types.Map
    attribute :field_2, Types.Map.options(optional: true)
    attribute :field_3, Types.Map.options(default: %{hello: :world})
  end
  """

  defstruct [:default, :optional]

  @doc "Valid options are :default and :optional"
  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_map(value), do: true
  def valid?(_value), do: false
end

defmodule Dry.Types.Struct do
  @moduledoc """
  Represents the struct type

  ## Examples:
  ```elixir
  schema do
    ttribute :field_1, Types.Struct
    attribute :field_2, Types.Struct.options(optional: true)
    attribute :field_2, Types.Struct.options(default: %Struct{a: 1})
  end
  """

  defstruct [:type, :default, :optional]

  @doc "Valid options are :type, :default and :optional"
  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_struct(value), do: true
  def valid?(_value), do: false
end

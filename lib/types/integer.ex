defmodule Dry.Types.Integer do
  @moduledoc """
  Represents the integer type

  ## Examples:
  ```elixir
  schema do
    ttribute :field_1, Types.Integer
    attribute :field_2, Types.Integer.options(optional: true)
    attribute :field_3, Types.Integer.options(default: 10)
  end
  """

  defstruct [:default, :optional]

  @doc "Valid options are :default and :optional"
  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_integer(value), do: true
  def valid?(_value), do: false
end

defmodule Dry.Types.Float do
  @moduledoc """
  Represents the float type

  ## Examples:
  ```elixir
  schema do
    ttribute :field_1, Types.Float
    attribute :field_2, Types.Float.options(optional: true)
    attribute :field_3, Types.Float.options(default: 15.5)
  end
  """

  defstruct [:default, :optional]

  @doc "Valid options are :default and :optional"
  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_float(value), do: true
  def valid?(_value), do: false
end

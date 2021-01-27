defmodule Dry.Types.Bool do
  @moduledoc """
  Represents the bool type

  ## Examples:
  ```elixir
  schema do
    ttribute :field_1, Types.Bool
    attribute :field_2, Types.Bool.options(optional: true)
    attribute :field_3, Types.Bool.options(default: false)
  end
  """

  defstruct [:default, :optional]

  @doc "Valid options are :default and :optional"
  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_boolean(value), do: true
  def valid?(_value), do: false
end

defmodule Dry.Types.String do
  @moduledoc """
  Represents the string type

  ## Examples:
  ```elixir
  schema do
    ttribute :field_1, Types.String
    attribute :field_2, Types.String.options(optional: true)
    attribute :field_3, Types.String.options(default: "default text")
  end
  """

  defstruct [:default, :optional]

  @doc "Valid options are :default and :optional"
  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_binary(value), do: true
  def valid?(_value), do: false
end

defmodule Dry.Types.Integer do
  @moduledoc """
    Represents the integer type
  """

  defstruct [:default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_integer(value), do: true
  def valid?(_value), do: false
end

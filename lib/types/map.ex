defmodule Dry.Types.Map do
  @moduledoc """
    Represents the map type
  """

  defstruct [:default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_map(value), do: true
  def valid?(_value), do: false
end

defmodule Dry.Types.Bool do
  @moduledoc """
    Represents the bool type
  """

  defstruct [:default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_boolean(value), do: true
  def valid?(_value), do: false
end

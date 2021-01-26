defmodule Dry.Types.String do
  @moduledoc """
    Represents the string type
  """

  defstruct [:default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_binary(value), do: true
  def valid?(_value), do: false
end

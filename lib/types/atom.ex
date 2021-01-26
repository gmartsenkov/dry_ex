defmodule Dry.Types.Atom do
  @moduledoc """
    Represents the atom type
  """

  defstruct [:default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_atom(value), do: true
  def valid?(_value), do: false
end

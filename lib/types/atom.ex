defmodule Dry.Types.Atom do
  @moduledoc """
  Represents the atom type

  ## Examples:
  ```elixir
  schema do
    attribute :field_1, Types.Atom
    attribute :field_2, Types.Atom.options(optional: true)
    attribute :field_3, Types.Atom.options(default: :atom)
  end
  ```
  """

  defstruct [:default, :optional]

  @doc "Valid options are :default and :optional"
  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid?(value) when is_atom(value), do: true
  def valid?(_value), do: false
end

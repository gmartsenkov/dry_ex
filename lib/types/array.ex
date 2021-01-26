defmodule Dry.Types.Array do
  @moduledoc """
    Represents the array type
  """

  defstruct [:of, :default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end
end

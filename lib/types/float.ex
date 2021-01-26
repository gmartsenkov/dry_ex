defmodule Dry.Types.Float do
  @moduledoc """
    Represents the float type
  """

  defstruct [:default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end
end

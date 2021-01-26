defmodule Dry.Types.Bool do
  @moduledoc """
    Represents the bool type
  """

  defstruct [:default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end
end

defmodule Dry.Types.String do
  @moduledoc """
    Represents the string type
  """

  defstruct [:default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end
end

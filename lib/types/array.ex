defmodule Dry.Types.Array do
  @moduledoc """
    Represents the array type
  """

  defstruct [:type, :default, :optional]

  def options(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def valid_list?(type, [head | tail]) do
    if Kernel.function_exported?(type, :valid?, 1) do
      if type.valid?(head), do: valid_list?(type, tail), else: {:error, head}
    else
      false
    end
  end

  def valid_list?(_type, []), do: true
  def valid_list?(_type, _value), do: false

  def valid?(value) when is_list(value), do: true
  def valid?(_value), do: false
end

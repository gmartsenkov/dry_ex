defmodule Dry.RuntimeError do
  @moduledoc """
    Error raised when a runtime error occures, for example when an attribute is not of the correct type.
  """
  defexception message: "Something went wrong"
end

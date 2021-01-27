defmodule Dry.ExampleStruct do
  @moduledoc false

  use Dry

  schema do
    attribute(:name, Dry.Types.String)
  end
end

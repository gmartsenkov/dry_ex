defmodule Dashboard.ExampleStruct do
  @moduledoc false

  use Dry

  schema do
    attribute(:name, :string)
  end
end

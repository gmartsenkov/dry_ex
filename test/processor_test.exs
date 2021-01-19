defmodule Dry.ProcessorTest do
  use ExSpec, async: true

  import Dry.Processor
  alias Dry.ExampleStruct

  @test_types [
    %{
      type: :string,
      value: "bob",
      invalid_value: 5,
      error: "[Dry.RuntimeError] - `5` has invalid type for :name. Expected type is :string"
    },
    %{
      type: :integer,
      value: 5,
      invalid_value: 5.5,
      error: "[Dry.RuntimeError] - `5.5` has invalid type for :name. Expected type is :integer"
    },
    %{
      type: :float,
      value: 10.5,
      invalid_value: "bob",
      error: "[Dry.RuntimeError] - `\"bob\"` has invalid type for :name. Expected type is :float"
    },
    %{
      type: :bool,
      value: true,
      invalid_value: %{age: 15},
      error:
        "[Dry.RuntimeError] - `%{age: 15}` has invalid type for :name. Expected type is :bool"
    },
    %{
      type: :atom,
      value: :dog,
      invalid_value: 100,
      error: "[Dry.RuntimeError] - `100` has invalid type for :name. Expected type is :atom"
    },
    %{
      type: :map,
      value: %{name: "Bob"},
      invalid_value: 100,
      error: "[Dry.RuntimeError] - `100` has invalid type for :name. Expected type is :map"
    },
    %{
      type: ExampleStruct,
      value: %ExampleStruct{name: "Bob"},
      invalid_value: 5,
      error:
        "[Dry.RuntimeError] - `5` has invalid type for :name. Expected type is Dry.ExampleStruct"
    },
    %{
      type: ExampleStruct,
      value: %{name: "Bob"},
      expected_value: %ExampleStruct{name: "Bob"},
      invalid_value: %{name: 1},
      error:
        "[Dry.RuntimeError] - Failed to initialise Dry.ExampleStruct with %{name: 1} for :name. Original error - [Dry.ExampleStruct] - `1` has invalid type for :name. Expected type is :string"
    }
  ]

  describe "#process" do
    context "types" do
      it "works as expected" do
        Enum.each(@test_types, fn test ->
          assert process(:name, test.type, test.value, nil, nil, nil) ==
                   {:name, Map.get(test, :expected_value, test.value)}

          assert_raise Dry.RuntimeError, test.error, fn ->
            process(:name, test.type, test.invalid_value, nil, nil, Dry.RuntimeError)
          end
        end)
      end
    end
  end
end

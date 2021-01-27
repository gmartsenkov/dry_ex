defmodule Dry.ProcessorTest do
  use ExSpec, async: true

  import Dry.Processor
  alias Dry.ExampleStruct
  alias Dry.Types

  @test_types [
    %{
      type: Types.String,
      value: "bob",
      invalid_value: 5,
      error: "[Test] - `5` has invalid type for :name. Expected type is Dry.Types.String"
    },
    %{
      type: Types.Integer,
      value: 5,
      invalid_value: 5.5,
      error: "[Test] - `5.5` has invalid type for :name. Expected type is Dry.Types.Integer"
    },
    %{
      type: Types.Float,
      value: 10.5,
      invalid_value: "bob",
      error: "[Test] - `\"bob\"` has invalid type for :name. Expected type is Dry.Types.Float"
    },
    %{
      type: Types.Bool,
      value: true,
      invalid_value: %{age: 15},
      error: "[Test] - `%{age: 15}` has invalid type for :name. Expected type is Dry.Types.Bool"
    },
    %{
      type: Types.Atom,
      value: :dog,
      invalid_value: 100,
      error: "[Test] - `100` has invalid type for :name. Expected type is Dry.Types.Atom"
    },
    %{
      type: Types.Map,
      value: %{name: "Bob"},
      invalid_value: 100,
      error: "[Test] - `100` has invalid type for :name. Expected type is Dry.Types.Map"
    },
    %{
      type: ExampleStruct,
      value: %ExampleStruct{name: "Bob"},
      invalid_value: 5,
      error: "[Test] - `5` has invalid type for :name. Expected type is Dry.ExampleStruct"
    },
    %{
      type: ExampleStruct,
      value: %{name: "Bob"},
      expected_value: %ExampleStruct{name: "Bob"},
      invalid_value: %{name: 1},
      error:
        "[Test] - An error occured when trying to initialize Dry.ExampleStruct with %{name: 1} for :name. Original error: [Dry.ExampleStruct] - `1` has invalid type for :name. Expected type is Dry.Types.String"
    },
    %{
      type: Types.Array.options(type: ExampleStruct),
      value: [%{name: "Bob"}],
      expected_value: [%ExampleStruct{name: "Bob"}],
      invalid_value: [%{name: 1}],
      error:
        "[Test] - An error occured when trying to initialize Dry.ExampleStruct with %{name: 1} for :name. Original error: [Dry.ExampleStruct] - `1` has invalid type for :name. Expected type is Dry.Types.String"
    }
  ]

  describe "#process" do
    context "types" do
      it "works as expected" do
        Enum.each(@test_types, fn test ->
          assert process(:name, test.type, test.value, Test) ==
                   {:name, Map.get(test, :expected_value, test.value)}

          assert_raise Dry.RuntimeError, test.error, fn ->
            process(:name, test.type, test.invalid_value, Test)
          end
        end)
      end
    end
  end
end

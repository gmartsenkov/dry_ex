defmodule Dry.Processor do
  @moduledoc false

  alias Dry.Types

  def process([name, :__func__], attr, module) do
    {name, apply(module, name, [attr])}
  end

  def process([name, type], attr, module) do
    value = Map.get(attr, name)

    process(name, type, value, module)
  end

  def process(name, %{default: default} = type, nil = _value, _module) when is_struct(type) do
    {name, default}
  end

  def process(name, %{optional: true} = type, nil = _value, _module) when is_struct(type) do
    {name, nil}
  end

  def process(name, _type, _value = nil, module) do
    raise Dry.RuntimeError,
      message: "[#{inspect(module)}] - Required attribute :#{name} is missing"
  end

  def process(name, %Types.Struct{type: type}, value, module) do
    Code.ensure_loaded(type)
    functions = type.__info__(:functions) |> Enum.into(%{})

    process_advanced(name, type, functions, value, module)
  end

  def process(name, %Types.Array{type: type}, value, module) do
    converted = convert_list(name, type, value, module)

    case Types.Array.valid_list?(type, converted) do
      true ->
        {name, converted}

      false ->
        invalid(name, type, value, module)

      {:error, problem_value} ->
        invalid(name, type, problem_value, module)
    end
  end

  def process(name, %{__struct__: type} = struct, value, module) when is_struct(struct) do
    Code.ensure_loaded(type)
    functions = type.__info__(:functions) |> Enum.into(%{})

    process_advanced(name, type, functions, value, module)
  end

  def process(name, _type = nil, value, _module) do
    {name, value}
  end

  def process(name, type, value, module) do
    Code.ensure_loaded(type)
    functions = type.__info__(:functions) |> Enum.into(%{})

    process_advanced(name, type, functions, value, module)
  end

  def process_advanced(name, type, %{__dry__: 0, valid?: 1}, value, module) when is_map(value) do
    case type.new(value) do
      {:ok, value} ->
        {name, value}

      {:error, message} ->
        raise Dry.RuntimeError,
          message:
            "[#{inspect(module)}] - An error occured when trying to initialize #{inspect(type)} with #{
              inspect(value)
            } for #{inspect(name)}. Original error: #{message}"
    end
  end

  def process_advanced(name, type, %{valid?: 1}, value, module) do
    if type.valid?(value), do: {name, value}, else: invalid(name, type, value, module)
  end

  def function?(attribute) do
    Enum.at(attribute, 1, nil) == :__func__
  end

  defp invalid(name, type, value, module) do
    raise Dry.RuntimeError,
      message:
        "[#{inspect(module)}] - `#{inspect(value)}` has invalid type for :#{name}. Expected type is #{
          inspect(type)
        }"
  end

  defp convert_list(name, type, list, module) when is_list(list) do
    Code.ensure_loaded(type)
    functions = type.__info__(:functions) |> Enum.into(%{})

    Enum.map(list, fn item ->
      {_name, converted} = process_advanced(name, type, functions, item, module)
      converted
    end)
  end

  defp convert_list(_name, _type, list, _module), do: list
end

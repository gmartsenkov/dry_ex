defmodule Dry.Processor do
  @moduledoc false

  def process([name, :__func__], attr, module) do
    {name, apply(module, name, [attr])}
  end

  def process([name, type, opts], attr, module) do
    default = Keyword.get(opts, :default, :__dry_undefined__)
    array = Keyword.get(opts, :array_of, nil)
    optional = Keyword.get(opts, :optional, false)
    value = Map.get(attr, name)

    if array do
      process(name, [array_of: array], value, default, optional, module)
    else
      process(name, type, value, default, optional, module)
    end
  end

  def process(name, _type, _value = nil, _default = :__dry_undefined__, _optional = false, module) do
    raise Dry.RuntimeError,
      message: "[#{inspect(module)}] - Required attribute :#{name} is missing"
  end

  def process(name, _type, value = nil, _default = :__dry_undefined__, _optional = true, _module) do
    {name, value}
  end

  def process(name, _type, _value = nil, default, _optional, _module) do
    {name, default}
  end

  def process(name, _type = nil, value, _default, _optional, _module) do
    {name, value}
  end

  def process(name, [array_of: type], value, default, optional, module) when is_list(value) do
    {name,
     Enum.map(value, fn x ->
       {_name, value} = process(name, type, x, default, optional, module)
       value
     end)}
  end

  def process(name, :string, value, _default, _optional, _module) when is_binary(value) do
    {name, value}
  end

  def process(name, :integer, value, _default, _optional, _module) when is_integer(value) do
    {name, value}
  end

  def process(name, :float, value, _default, _optional, _module) when is_float(value) do
    {name, value}
  end

  def process(name, :atom, value, _default, _optional, _module) when is_atom(value) do
    {name, value}
  end

  def process(name, :bool, value, _default, _optional, _module) when is_boolean(value) do
    {name, value}
  end

  def process(name, :map, value, _default, _optional, _module) when is_map(value) do
    {name, value}
  end

  def process(name, type, value, _default, _optional, module) when is_map(value) do
    if Kernel.function_exported?(type, :__dry__, 0) do
      try do
        {name, type.new!(value)}
      rescue
        e in Dry.RuntimeError ->
          reraise Dry.RuntimeError,
                  [
                    message:
                      "[#{inspect(module)}] - Failed to initialise #{inspect(type)} with #{
                        inspect(value)
                      } for #{inspect(name)}. Original error - #{e.message}"
                  ],
                  __STACKTRACE__
      end
    else
      invalid(name, type, value, module)
    end
  end

  def process(name, type, value, _default, _optional, module) when is_struct(value) do
    if value.__struct__ == type do
      {name, value}
    else
      invalid(name, type, value, module)
    end
  end

  def process(name, type, value, _default, _optional, module) do
    invalid(name, type, value, module)
  end

  defp invalid(name, type, value, module) do
    raise Dry.RuntimeError,
      message:
        "[#{inspect(module)}] - `#{inspect(value)}` has invalid type for :#{name}. Expected type is #{
          inspect(type)
        }"
  end

  def function?(attribute) do
    Enum.at(attribute, 1, nil) == :__func__
  end
end

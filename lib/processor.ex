defmodule Dry.Processor do
  @moduledoc false

  def process([name, :__func__], attr, module) do
    {name, apply(module, name, [attr])}
  end

  def process([name, type, opts], attr, module) do
    default = Keyword.get(opts, :default, :__dry_undefined__)
    optional = Keyword.get(opts, :optional, false)
    value = Map.get(attr, name)
    process(name, type, value, default, optional, module)
  end

  def process(name, _type, _value = nil, _default = :__dry_undefined__, _optional = false, module) do
    raise Dry.RuntimeError, message: "[#{module}] - Required attribute :#{name} is missing"
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
        "[#{module}] - `#{inspect(value)}` has invalid type for :#{name}. Expected type is #{type}"
  end

  def function?(attribute) do
    Enum.at(attribute, 1, nil) == :__func__
  end
end

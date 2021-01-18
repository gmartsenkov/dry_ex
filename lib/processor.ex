defmodule Dry.Processor do
  @moduledoc false

  def process([name, :__func__], attr, module) do
    {name, apply(module, name, [attr])}
  end

  def process([name, type, opts], attr, _module) do
    default = Keyword.get(opts, :default, :__dry_undefined__)
    optional = Keyword.get(opts, :optional, false)
    value = Map.get(attr, name)

    process(name, type, value, default, optional)
  end

  def process(name, _type, _value = nil, _default = :__dry_undefined__, _optional = false) do
    raise Dry.RuntimeError, message: "Required attribute :#{name} is missing"
  end

  def process(name, _type, value = nil, _default = :__dry_undefined__, _optional = true) do
    {name, value}
  end

  def process(name, _type, _value = nil, default, _optional) do
    {name, default}
  end

  def process(name, _type, value, _default, _optional) do
    {name, value}
  end
end

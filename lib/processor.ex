defmodule Dry.Processor do
  def process([name, :__func__], attr, module) do
    {name, apply(module, name, [attr])}
  end

  def process([name, type, opts], attr, _module) do
    default = Keyword.get(opts, :default, :__dry_undefined__)
    value = Map.get(attr, name)

    process(name, type, value, default)
  end

  def process(name, _type, _value = nil, _default = :__dry_undefined__) do
    raise Dry.Error, message: "Required attribute :#{name} is missing"
  end

  def process(name, _type, _value = nil, default) do
    {name, default}
  end

  def process(name, _type, value, _default) do
    {name, value}
  end
end

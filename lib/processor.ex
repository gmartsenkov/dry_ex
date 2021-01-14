defmodule Dry.Processor do
  def process([name, :__func__], attr, module) do
    {name, apply(module, name, [attr])}
  end

  def process([name | _rest], attr, _module) do
    {name, Map.get(attr, name)}
  end
end

defmodule DryTest do
  use ExSpec, async: true

  doctest Dry

  defmodule Parent do
    use Dry

    schema do
      attribute(:name)
    end
  end

  defmodule Test do
    use Dry

    schema do
      attribute(:name, :string)
      attribute(:age, :integer, optional: true)
      attribute(:height, default: 190)
      attribute(:country, :string, default: "UK")
      attribute(:siblings, array_of: :string, default: ["Bob", "Mark"])
      attribute(:parents, array_of: Parent, optional: true)

      attribute :is_adult do
        (entity.age || 0) >= 18
      end

      attribute :tall do
        (entity.height || 0) > 180
      end
    end
  end

  describe "#new!" do
    it "generates the correct struct" do
      assert Test.new!(%{
               name: "Rob",
               age: 18,
               height: 169,
               country: "BG",
               siblings: ["John", "Bob"],
               parents: [%{name: "Mark"}]
             }) == %Test{
               name: "Rob",
               age: 18,
               height: 169,
               is_adult: true,
               siblings: ["John", "Bob"],
               parents: [%Parent{name: "Mark"}],
               tall: false,
               country: "BG"
             }
    end

    it "works when a default is set" do
      assert Test.new!(%{name: "Bob", age: 5}) == %Test{
               name: "Bob",
               age: 5,
               height: 190,
               is_adult: false,
               siblings: ["Bob", "Mark"],
               country: "UK",
               tall: true
             }
    end

    context "when non-optional attribute is missing" do
      it "raises an exception" do
        assert_raise Dry.RuntimeError,
                     "[DryTest.Test] - Required attribute :name is missing",
                     fn ->
                       Test.new!(%{})
                     end
      end
    end

    context "when a list attribute has the wrong type" do
      it "raises an exception" do
        assert_raise Dry.RuntimeError,
                     "[DryTest.Test] - `1` has invalid type for :siblings. Expected type is :string",
                     fn ->
                       Test.new!(%{name: "Bob", age: 5, siblings: ["bob", 1]})
                     end

        assert_raise Dry.RuntimeError,
                     "[DryTest.Test] - `\"Bob\"` has invalid type for :parents. Expected type is [array_of: DryTest.Parent]",
                     fn ->
                       Test.new!(%{name: "Bob", age: 5, parents: "Bob"})
                     end

        assert_raise Dry.RuntimeError,
                     "[DryTest.Test] - `\"Bob\"` has invalid type for :parents. Expected type is DryTest.Parent",
                     fn ->
                       Test.new!(%{name: "Bob", age: 5, parents: ["Bob"]})
                     end

        assert_raise Dry.RuntimeError,
                     "[DryTest.Test] - `1` has invalid type for :siblings. Expected type is [array_of: :string]",
                     fn ->
                       Test.new!(%{name: "Bob", age: 5, siblings: 1})
                     end
      end
    end

    context "when optional attribute is missing" do
      it "returns the correct struct" do
        assert Test.new!(%{name: "Bob", height: 190}) == %Test{
                 name: "Bob",
                 age: nil,
                 height: 190,
                 is_adult: false,
                 country: "UK",
                 siblings: ["Bob", "Mark"],
                 tall: true
               }
      end
    end
  end

  describe "#new" do
    context "when no error occurs" do
      it "returns an ok tuple" do
        {:ok, result} = Test.new(%{name: "Rob", age: 18, height: 169, country: "BG"})

        assert result == %Test{
                 name: "Rob",
                 age: 18,
                 height: 169,
                 is_adult: true,
                 siblings: ["Bob", "Mark"],
                 tall: false,
                 country: "BG"
               }
      end
    end

    context "when an error occurs" do
      it "returns an error tuple" do
        {:error, error} = Test.new(%{})
        assert error == "[DryTest.Test] - Required attribute :name is missing"
      end
    end
  end

  describe "__dry__" do
    it "returns true" do
      assert Test.__dry__() == true
    end
  end
end

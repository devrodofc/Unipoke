defmodule UnipokeTest do
  use ExUnit.Case
  doctest Unipoke

  test "greets the world" do
    assert Unipoke.hello() == :world
  end
end

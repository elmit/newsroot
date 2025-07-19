defmodule NewsrootTest do
  use ExUnit.Case
  doctest Newsroot

  test "greets the world" do
    assert Newsroot.hello() == :world
  end
end

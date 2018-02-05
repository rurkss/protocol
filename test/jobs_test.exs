defmodule JobsTest do
  use ExUnit.Case
  doctest Jobs

  test "greets the world" do
    assert Jobs.hello() == :world
  end
end

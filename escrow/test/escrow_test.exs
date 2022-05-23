defmodule EscrowTest do
  use ExUnit.Case
  doctest Escrow

  test "greets the world" do
    assert Escrow.hello() == :world
  end
end

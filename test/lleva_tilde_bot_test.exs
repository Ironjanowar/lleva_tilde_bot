defmodule LlevaTildeBotTest do
  use ExUnit.Case
  doctest LlevaTildeBot

  test "greets the world" do
    assert LlevaTildeBot.hello() == :world
  end
end

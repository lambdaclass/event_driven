defmodule NotificationTest do
  use ExUnit.Case
  doctest Notification

  test "greets the world" do
    assert Notification.hello() == :world
  end
end

defmodule TextSiteTest do
  use ExUnit.Case
  doctest TextSite

  test "greets the world" do
    assert TextSite.hello() == :world
  end
end

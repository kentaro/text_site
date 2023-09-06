defmodule TextSite.Counter do
  use GenServer

  @impl true
  def init(counter \\ 0) do
    # TODO: どこかにcountを保存しておいたのから持ってくる
    {:ok, counter}
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def handle_call(:counter, _from, state) do
    {:reply, state, state + 1}
  end
end

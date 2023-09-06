defmodule TextSite.Counter do
  use GenServer

  @table_name :counter_table
  @key :counter

  @impl true
  def init(_opts) do
    {:ok, table} = :dets.open_file(@table_name, type: :set)

    if :dets.lookup(table, @key) == [] do
      :dets.insert(table, {@key, 0})
      :dets.sync(table)
    end

    {:ok,
     %{
       table: table,
       key: @key
     }}
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def handle_call(:counter, _from, state) do
    count =
      :dets.update_counter(
        state.table,
        state.key,
        1
      )

    :dets.sync(state.table)

    {:reply, count, state}
  end
end

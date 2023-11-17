defmodule AOCUtilsCase do
  use ExUnit.CaseTemplate

  setup context do
    # Store application environment before the test
    store_env = Application.get_all_env(:advent_of_code_utils)

    # Clear values when tagged with clear: :value
    if to_clear = context[:clear], do: Application.delete_env(:advent_of_code_utils, to_clear)

    on_exit(fn ->
      # Clear the application environment completely
      :advent_of_code_utils
      |> Application.get_all_env()
      |> Enum.map(fn {k, _} -> Application.delete_env(:advent_of_code_utils, k) end)

      # Restore the values from before the test
      Enum.map(store_env, fn {k, v} -> put_env(k, v) end)
    end)
  end

  using do
    quote do
      import unquote(__MODULE__)
    end
  end

  def put_env(key, val), do: Application.put_env(:advent_of_code_utils, key, val)
end

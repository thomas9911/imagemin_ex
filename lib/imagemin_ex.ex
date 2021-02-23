defmodule ImageminEx do
  @moduledoc """
  A Elixir wrapper around imagemin-cli
  """

  alias ImageminEx.Config
  alias ImageminEx.Command

  @doc """
  Returns a {:ok, binary} with the help text

  ```
  iex> ImageminEx.help()
  ```
  """
  def help(cfg \\ nil) do
    cfg = fetch_config(cfg)
    {program, args, _} = Config.make_command(cfg)
    Command.run_direct(program, args ++ ["--help"])
  end

  @doc """
  Prints help to console
  """
  def print_help(cfg \\ nil) do
    {:ok, help_text} = help(cfg)
    IO.puts(help_text)
  end

  @doc """
  Converts src to dest with the given config (or with the default config).
  You can specify the used plugins in the config.
  """
  def convert(src, dest, cfg \\ nil) do
    cfg = fetch_config(cfg)
    {program, args, opts} = Config.make_command(cfg)

    with {:ok, device} <- open_file(dest),
         {:ok, _output} <- Command.run_write(program, args ++ [src] ++ opts, device) do
      :ok
    end
  end

  defp open_file(path) do
    File.open(path, [:binary, :write])
  end

  defp fetch_config(%Config{} = cfg), do: cfg
  defp fetch_config(_), do: Config.default()
end

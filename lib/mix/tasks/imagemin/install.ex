defmodule Mix.Tasks.Imagemin.Install do
  @moduledoc "Installs imagemin-cli locally using npm"
  @shortdoc @moduledoc

  use Mix.Task

  @impl Mix.Task
  def run([arg | _]) when arg in ["-h", "h"] do
    Mix.shell().info(@shortdoc)
  end

  def run([arg | _]) when arg in ["--help", "help"] do
    Mix.shell().info(@moduledoc)
  end

  def run(_args) do
    case System.find_executable("npm") do
      nil ->
        Mix.shell().error("npm is not found, you probably need to install nodejs")

      _ ->
        Mix.shell().cmd("npm install imagemin-cli",
          env: %{
            "NPM_CONFIG_FUND" => "false",
            "NPM_CONFIG_LOGLEVEL" => "silent",
            "NPM_CONFIG_PROGRESS" => "false"
          }
        )
    end
  end
end

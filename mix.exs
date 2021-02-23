defmodule ImageminEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :imagemin_ex,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      # integration test written in bash
      {:i_test, "cmd sh ./run_test.sh"}
    ]
  end
end

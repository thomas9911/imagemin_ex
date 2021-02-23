defmodule ImageminEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :imagemin_ex,
      package: package(),
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp package do
    [
      description: "A Elixir wrapper around imagemin-cli",
      licenses: ["Unlicense"],
      links: %{
        "GitHub" => "https://github.com/thomas9911/imagemin_ex"
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      # integration test written in bash
      {:i_test, "cmd sh ./run_test.sh"}
    ]
  end
end

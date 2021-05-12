defmodule ImageminEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :imagemin_ex,
      package: package(),
      version: "0.1.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      preferred_cli_env: [ci_test: :test],
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
      {:ci_test, ["imagemin.install", "test"]}
    ]
  end
end

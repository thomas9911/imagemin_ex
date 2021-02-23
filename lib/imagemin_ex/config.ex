defmodule ImageminEx.Config do
  @moduledoc """
  Module holding configuration
  """
  @type t :: %__MODULE__{}

  @default_node_path "node"
  @default_imagemin_cli_path "node_modules/imagemin-cli/cli.js"
  @default_plugins [
    "gifsicle",
    "jpegtran",
    "optipng",
    "svgo"
  ]

  defstruct [:node_path, :imagemin_cli_path, plugins: @default_plugins]

  def default do
    %__MODULE__{
      node_path: @default_node_path,
      imagemin_cli_path: @default_imagemin_cli_path
    }
  end

  def override(%__MODULE__{} = cfg, extra) when is_list(extra) do
    struct(cfg, extra)
  end

  def append_plugins(%__MODULE__{plugins: plugins} = cfg, extra_plugins) do
    extra_plugins = List.wrap(extra_plugins)
    %{cfg | plugins: plugins ++ extra_plugins}
  end

  @spec make_command(__MODULE__.t()) :: {binary, [binary]}
  def make_command(%__MODULE__{
        node_path: nil,
        imagemin_cli_path: imagemin_cli_path,
        plugins: plugins
      }) do
    {imagemin_cli_path, [], prefix_plugins(plugins)}
  end

  def make_command(%__MODULE__{
        node_path: node_path,
        imagemin_cli_path: imagemin_cli_path,
        plugins: plugins
      }) do
    {node_path, [imagemin_cli_path], prefix_plugins(plugins)}
  end

  defp prefix_plugins(plugins) do
    Enum.map(plugins, fn plugin -> "--plugin=#{plugin}" end)
  end
end

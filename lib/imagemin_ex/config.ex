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

  defstruct [:node_path, :imagemin_cli_path, plugins: @default_plugins, extra_plugin_options: []]

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

  def append_plugin_options(
        %__MODULE__{extra_plugin_options: extra_plugin_options} = cfg,
        keyword
      ) do
    extra_plugin_options = keyword_merge(extra_plugin_options, keyword)
    %{cfg | extra_plugin_options: extra_plugin_options}
  end

  @spec make_command(__MODULE__.t()) :: {binary, [binary], [binary]}
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
        plugins: plugins,
        extra_plugin_options: extra_plugin_options
      }) do
    options = Enum.concat(prefix_plugins(plugins), format_plugin_options(extra_plugin_options))
    {node_path, [imagemin_cli_path], options}
  end

  defp prefix_plugins(plugins) when is_list(plugins) do
    Enum.map(plugins, fn plugin -> "--plugin=#{plugin}" end)
  end

  defp prefix_plugins(plugin) do
    plugin
    |> List.wrap()
    |> prefix_plugins()
  end

  defp format_plugin_options(options) when is_list(options) do
    options
    |> expand_keyword()
    |> Enum.map(&do_format_plugin_options/1)
  end

  defp expand_keyword(options) when is_list(options) do
    Enum.flat_map(options, fn {k, v} ->
      v
      |> expand_keyword()
      |> Enum.map(&[k, &1])
    end)
  end

  defp expand_keyword(options) do
    [options]
  end

  defp do_format_plugin_options(x) do
    args = x |> List.flatten()
    {last, args} = List.pop_at(args, -1)
    "--plugin.#{Enum.join(args, ".")}=#{last}"
  end

  def keyword_merge(original, override) do
    Keyword.merge(original, override, &do_keyword_merge/3)
  end

  defp do_keyword_merge(_, left, right) when is_list(left) and is_list(right) do
    keyword_merge(left, right)
  end

  defp do_keyword_merge(_, _left, right) do
    right
  end
end

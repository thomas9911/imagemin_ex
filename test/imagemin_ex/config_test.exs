defmodule ImageminEx.ConfigTest do
  use ExUnit.Case, async: true
  doctest ImageminEx

  alias ImageminEx.Config

  test "default" do
    assert %Config{} = Config.default()
  end

  test "override" do
    assert %Config{node_path: "my_node", imagemin_cli_path: "./cli.js"} =
             Config.default()
             |> Config.override(node_path: "my_node", imagemin_cli_path: "./cli.js")
  end

  describe "append_plugins" do
    test "one" do
      assert %Config{plugins: plugins} =
               Config.default()
               |> Config.append_plugins("my_plugin")

      assert Enum.member?(plugins, "my_plugin")
    end

    test "multiple" do
      assert %Config{plugins: plugins} =
               Config.default()
               |> Config.append_plugins(["my_plugin", "another_plugin"])

      assert Enum.member?(plugins, "my_plugin")
      assert Enum.member?(plugins, "another_plugin")
    end
  end

  describe "make_command" do
    test "node path set" do
      assert {"my_node", ["./cli.js"], _default_plugins} =
               Config.default()
               |> Config.override(node_path: "my_node", imagemin_cli_path: "./cli.js")
               |> Config.make_command()
    end

    test "node path unset" do
      assert {"my_command", [], _default_plugins} =
               Config.default()
               |> Config.override(node_path: nil, imagemin_cli_path: "my_command")
               |> Config.make_command()
    end

    test "plugins format correctly, binary" do
      assert {_, _, extra_args} =
               Config.default()
               |> Config.override(plugins: "my_plugin")
               |> Config.make_command()

      assert ["--plugin=my_plugin"] == extra_args
    end

    test "plugins format correctly, list" do
      assert {_, _, extra_args} =
               Config.default()
               |> Config.override(plugins: ["my_plugin"])
               |> Config.make_command()

      assert ["--plugin=my_plugin"] == extra_args
    end

    test "plugins multiple format correctly" do
      assert {_, _, extra_args} =
               Config.default()
               |> Config.override(plugins: ["my_plugin", "another_plugin"])
               |> Config.make_command()

      assert ["--plugin=my_plugin", "--plugin=another_plugin"] == extra_args
    end

    test "plugin options format correctly" do
      assert {_, _, extra_args} =
               Config.default()
               |> Config.override(plugins: [])
               |> Config.append_plugin_options(webp: [quality: 95, preset: "icon"])
               |> Config.make_command()

      assert ["--plugin.webp.quality=95", "--plugin.webp.preset=icon"] == extra_args
    end

    test "options format correctly" do
      assert {_, _, extra_args} =
               Config.default()
               |> Config.override(plugins: [:my_plugin])
               |> Config.append_plugin_options(webp: [quality: 95, preset: "icon"])
               |> Config.make_command()

      assert ["--plugin=my_plugin", "--plugin.webp.quality=95", "--plugin.webp.preset=icon"] ==
               extra_args
    end
  end

  test "append_plugin_options" do
    assert %{extra_plugin_options: extra_plugin_options} =
             Config.default()
             |> Config.append_plugin_options(webp: [quality: 95])
             |> Config.append_plugin_options(webp: [preset: "icon"])

    assert [webp: [quality: 95, preset: "icon"]] == extra_plugin_options
  end

  describe "keyword merge" do
    test "works" do
      assert [a: [b: 1, c: 2]] = Config.keyword_merge([a: [b: 1]], a: [c: 2])
    end

    test "override original" do
      assert [a: [b: 2]] = Config.keyword_merge([a: [b: 1]], a: [b: 2])
    end
  end
end

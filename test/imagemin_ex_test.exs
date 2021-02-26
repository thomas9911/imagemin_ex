defmodule ImageminExTest do
  use ExUnit.Case, async: true
  doctest ImageminEx

  alias ImageminEx.Config

  @image_path Path.join(__DIR__, "imagemin_ex_test")

  setup_all do
    tmp_folder = Path.join(System.tmp_dir!(), "#{__MODULE__}")
    File.mkdir!(tmp_folder)
    on_exit(fn -> File.rm_rf!(tmp_folder) end)
    {:ok, tmp_dir: tmp_folder}
  end

  def gen_input_output(tmp_dir, file) do
    input = Path.join(@image_path, file)
    output = Path.join(tmp_dir, file)
    {input, output}
  end

  test "converts image to destination", %{tmp_dir: tmp_dir} do
    {input, output} = gen_input_output(tmp_dir, "example.jpg")

    assert :ok == ImageminEx.convert(input, output)
    assert {:ok, %{size: size}} = File.stat(output)

    assert size > 0
  end

  test "errors on non existing image", %{tmp_dir: tmp_dir} do
    {input, output} = gen_input_output(tmp_dir, "not_existing.jpg")

    assert {:error, :enoent} == ImageminEx.convert(input, output)
  end

  test "invalid node command", %{tmp_dir: tmp_dir} do
    {input, output} = gen_input_output(tmp_dir, "example.jpg")
    cfg = Config.default() |> Config.override(node_path: "not_existing_binary")

    assert {:error, :command_not_found} == ImageminEx.convert(input, output, cfg)
  end

  test "invalid imagemin path", %{tmp_dir: tmp_dir} do
    {input, output} = gen_input_output(tmp_dir, "example.jpg")
    cfg = Config.default() |> Config.override(imagemin_cli_path: "not_existing_file")

    assert {:error, :image_convert_failed} == ImageminEx.convert(input, output, cfg)
  end
end

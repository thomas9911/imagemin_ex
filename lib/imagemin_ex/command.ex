defmodule ImageminEx.Command do
  @moduledoc """
  Wrapper around `System.cmd/3`
  """
  def run_direct(program, args) do
    case System.cmd(program, args) do
      {output, 0} -> {:ok, output}
      {output, _} -> {:error, output}
    end
  end

  def run_write(program, args, device) do
    case System.cmd(program, args, into: IO.binstream(device, :line), stderr_to_stdout: true) do
      {_, 0} -> :ok
      {_, _} -> {:error, :image_convert_failed}
    end
  rescue
    _ in ErlangError -> {:error, :command_not_found}
  end
end

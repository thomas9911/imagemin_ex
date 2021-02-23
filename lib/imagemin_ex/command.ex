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
    case System.cmd(program, args, into: IO.binstream(device, :line)) do
      {output, 0} -> {:ok, output}
      {output, _} -> {:error, output}
    end
  end
end

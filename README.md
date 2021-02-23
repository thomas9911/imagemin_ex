# ImageminEx

A Elixir wrapper around imagemin-cli

## Installation

If [available in Hex](https://hexdocs.pm/imagemin_ex/0.1.0), the package can be installed
by adding `imagemin_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:imagemin_ex, "~> 0.1.0"}
  ]
end
```

Also currently you need to manually install imagemin-cli.
I installed it by creating a new npm package and install it there:

```sh
npm init -y
npm install imagemin-cli
```

If you install it globally you need to update the default config:

```elixir
config = ImageminEx.Config.default()
# unset the node path
config = ImageminEx.Config.override(config, node_path: nil)
```

## Usage

Currently only convert and help functions are implemented:

```elixir
# convert with the default config
ImageminEx.convert("source/path.my_extension", "destination/path.my_extension")

# convert with custom config
config = ImageminEx.Config.default()
config = ImageminEx.Config.override(config, node_path: nil)
config = ImageminEx.Config.append_plugins(config, "my_plugin")
config = ImageminEx.Config.append_plugins(config, ["just" "a bunch of", "plugins"])

ImageminEx.convert("source/path.my_extension", "destination/path.my_extension", config)
```

```elixir
# prints to the console
ImageminEx.print_help()

# returns a {:ok, binary} with the help text
ImageminEx.help()
```

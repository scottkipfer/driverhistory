defmodule Driverhistory.MixProject do
  use Mix.Project

  def project do
    [
      app: :driverhistory,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      escript: escript_config(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.12"}
    ]
  end
  defp escript_config do
    [
      main_module: CLI
    ]
  end
end

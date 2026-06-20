defmodule Unipoke.Commands do
  @moduledoc """
  Roteador de comandos do bot Unipoke.

  Cada comando é tratado em seu próprio módulo dentro de `Unipoke.Commands.*`.

  Comandos suportados:
    !randompoke
    !pokedex <pokemon>
    !fraquezas <pokemon>
    !status
    !status <pokemon> <atributo>
    !fusao <pokemon> <pokemon>
  """

  alias Nostrum.Api.Message
  alias Unipoke.Commands.{Randompoke, Pokedex, Fraquezas, Stat, Fusion, Help}

  def handle_command(command, channel_id) when is_binary(command) do
    parts = String.split(command, ~r/\s+/, trim: true)

    case parts do

      # Comando sem parâmetros
      ["!help"] ->
        Help.run(channel_id)

      ["!randompoke"] ->
        Randompoke.run(channel_id)

      ["!status"] ->
        Stat.list_attributes(channel_id)

      # Comandos com 1 parâmetro
      ["!pokedex", arg] ->
        Pokedex.run(arg, channel_id)

      ["!fraqueza", arg] ->
        Fraquezas.run(arg, channel_id)

      # Comandos com 2 parâmetros
      ["!status", arg, attr] ->
        Stat.run(arg, attr, channel_id)

      ["!fusao", p1, p2] ->
        Fusion.run(p1, p2, channel_id)

      # Caso o comando não seja reconhecido
      _ ->
        Message.create(channel_id, "Comando não reconhecido.")
    end
  end
end

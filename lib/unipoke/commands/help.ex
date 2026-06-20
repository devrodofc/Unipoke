defmodule Unipoke.Commands.Help do
  @moduledoc """
  Comando !help — mostra todos os comandos disponíveis do bot Unipoke.
  """

  alias Nostrum.Api.Message

  def run(channel_id) do
    texto = """
    🤖 **Comandos disponíveis do Unipoke:**

    🌀 `!randompoke`
    → Mostra um Pokémon aleatório.

    📘 `!pokedex <pokemon>`
    → Exibe informações básicas de um Pokémon (tipos, habilidades e imagem).

    🧠 `!status`
    → Mostra a lista de atributos disponíveis.

    🧠 `!status <pokemon> <atributo>`
    → Exibe o valor base do atributo informado.

    🔥 `!fraqueza <pokemon>`
    → Mostra as resistências e fraquezas do Pokémon.

    ⚡ `!fusao <pokemon1> <pokemon2>`
    → Cria uma fusão divertida com os nomes de dois Pokémon.

    ❓ `!help`
    → Mostra esta lista de comandos.

    ---
    *Use os nomes em minúsculas e sem acento, por exemplo:*
    `!pokedex pikachu` ou `!fraquezas charizard`
    """

    Message.create(channel_id, texto)
  end
end

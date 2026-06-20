defmodule Unipoke.Commands.Fusion do
  @moduledoc """
  Comando !fusao <pokemon1> <pokemon2>
  Une os nomes de dois Pokémon em um nome híbrido divertido.
  """

  alias Nostrum.Api.Message

  def run(poke1, poke2, channel_id) do
    fusion_name = combine_names(poke1, poke2)
    Message.create(channel_id, "Agora você tem: **#{fusion_name}**!")
  end

  defp combine_names(poke1, poke2) do
    name1 = String.downcase(poke1)
    name2 = String.downcase(poke2)

    # calcula o ponto de corte (metade do nome, arredondado para cima)
    half1 = trunc(Float.ceil(String.length(name1) / 2))
    half2 = trunc(Float.ceil(String.length(name2) / 2))

    part1 = String.slice(name1, 0, half1)
    part2 = String.slice(name2, half2, String.length(name2) - half2)

    fused = part1 <> part2
    String.capitalize(fused)
  end
end

defmodule Unipoke.Commands.Pokedex do
  @moduledoc "Comando !pokedex <pokemon>"
  alias Nostrum.Api.Message
  @base "https://pokeapi.co/api/v2"
  @finch UnipokeFinch

  def run(arg, channel_id) do
    case get_pokemon(arg) do
      {:ok, p} ->
        types = Enum.map_join(p["types"], ", ", &String.capitalize(&1["type"]["name"]))
        abilities = Enum.map_join(p["abilities"], ", ", & &1["ability"]["name"])
        sprite = get_in(p, ["sprites", "other", "official-artwork", "front_default"])
        text = "**##{p["id"]} - #{String.capitalize(p["name"])}**\nTipos: #{types}\nHabilidades: #{abilities}"
        embed = %{title: "Pokédex", description: text, image: %{url: sprite}}
        Message.create(channel_id, %{embeds: [embed]})
      _ -> Message.create(channel_id, "Pokémon não encontrado.")
    end
  end

  defp get_pokemon(name) do
    req = Finch.build(:get, "#{@base}/pokemon/#{URI.encode(name)}")
    with {:ok, %Finch.Response{status: 200, body: body}} <- Finch.request(req, @finch),
         {:ok, json} <- Jason.decode(body) do
      {:ok, json}
    else _ -> {:error, :fail} end
  end
end

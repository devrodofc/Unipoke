defmodule Unipoke.Commands.Randompoke do
  @moduledoc "Comando !randompoke — sorteia um Pokémon aleatório."
  alias Nostrum.Api.Message
  @base "https://pokeapi.co/api/v2"
  @finch UnipokeFinch

  def run(channel_id) do
    id = Enum.random(1..898)
    case get_pokemon("#{id}") do
      {:ok, p} ->
        name = String.capitalize(p["name"])
        sprite = get_in(p, ["sprites", "other", "official-artwork", "front_default"])
        embed = %{title: "Pokémon aleatório", description: "**##{p["id"]} - #{name}**", image: %{url: sprite}}
        Message.create(channel_id, %{embeds: [embed]})
      _ ->
        Message.create(channel_id, "Erro ao sortear Pokémon.")
    end
  end

  defp get_pokemon(id) do
    url = "#{@base}/pokemon/#{id}"
    req = Finch.build(:get, url)
    with {:ok, %Finch.Response{status: 200, body: body}} <- Finch.request(req, @finch),
         {:ok, json} <- Jason.decode(body) do
      {:ok, json}
    else _ -> {:error, :fail} end
  end
end

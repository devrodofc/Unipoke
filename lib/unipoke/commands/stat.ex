defmodule Unipoke.Commands.Stat do
  @moduledoc """
  Comando !status

  - `!status` → mostra os atributos disponíveis
  - `!status <pokemon> <atributo>` → mostra o valor base do atributo escolhido

  Atributos disponíveis:
  hp, attack, defense, special-attack, special-defense, speed
  """

  alias Nostrum.Api.Message
  @base "https://pokeapi.co/api/v2"
  @finch UnipokeFinch

  # -------------------------------------------------
  # !status → sem parâmetros → lista atributos disponíveis
  # -------------------------------------------------
  def list_attributes(channel_id) do
    texto = """
    **Atributos disponíveis para `!status`:**
    - hp
    - attack
    - defense
    - special-attack
    - special-defense
    - speed

    **Exemplos:**
    `!status pikachu attack`
    `!status mewtwo speed`
    """

    Message.create(channel_id, texto)
  end

  # -------------------------------------------------
  # !status <pokemon> <atributo> → mostra valor do atributo
  # -------------------------------------------------
  def run(pokemon, atributo, channel_id) do
    case get_pokemon(pokemon) do
      {:ok, p} ->
        case Enum.find(p["stats"], fn s -> s["stat"]["name"] == String.downcase(atributo) end) do
          nil ->
            Message.create(channel_id, "Atributo '#{atributo}' não encontrado. Use `!stat` para ver todos os disponíveis.")

          stat_map ->
            base = stat_map["base_stat"]
            Message.create(channel_id, "#{String.capitalize(p["name"])} — #{atributo}: #{base}")
        end

      {:error, :not_found} ->
        Message.create(channel_id, "Pokémon não encontrado.")

      {:error, reason} ->
        Message.create(channel_id, "Erro ao buscar Pokémon: #{inspect(reason)}")
    end
  end

  # -------------------------------------------------
  # Helpers para busca na API
  # -------------------------------------------------
  defp get_pokemon(name) do
    url = "#{@base}/pokemon/#{URI.encode(name)}"
    fetch_json(url)
  end

  defp fetch_json(url) do
    req = Finch.build(:get, url, [{"Accept", "application/json"}])

    case Finch.request(req, @finch) do
      {:ok, %Finch.Response{status: status, body: body}} when status in 200..299 ->
        case Jason.decode(body) do
          {:ok, json} -> {:ok, json}
          {:error, _} -> {:error, :invalid_json}
        end

      {:ok, %Finch.Response{status: 404}} ->
        {:error, :not_found}

      {:ok, %Finch.Response{status: status}} ->
        {:error, {:http_status, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end

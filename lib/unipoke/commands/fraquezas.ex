defmodule Unipoke.Commands.Fraquezas do
  @moduledoc "Comando !fraqueza <pokemon> — exibe resistências e fraquezas."

  alias Nostrum.Api.Message
  @base "https://pokeapi.co/api/v2"
  @finch UnipokeFinch

  @all_types [
    "normal","fire","water","electric","grass","ice","fighting",
    "poison","ground","flying","psychic","bug","rock",
    "ghost","dragon","dark","steel","fairy"
  ]

  @doc "Entrada: run(<pokemon|id>, channel_id)"
  def run(arg, channel_id) do
    case get_pokemon(arg) do
      {:ok, p} ->
        poke_types = Enum.map(p["types"], & &1["type"]["name"]) # tipos em inglês pela API

        type_data_map = fetch_types_map(@all_types)

        defensivos_map =
          @all_types
          |> Enum.map(fn attacker ->
            mult =
              Enum.reduce(poke_types, 1.0, fn pt, acc ->
                ptdata = Map.get(type_data_map, pt)

                mult_for_pt =
                  if ptdata == nil do
                    1.0
                  else
                    rel = ptdata["damage_relations"]

                    cond do
                      attacker in Enum.map(rel["double_damage_from"], & &1["name"]) -> 2.0
                      attacker in Enum.map(rel["half_damage_from"], & &1["name"]) -> 0.5
                      attacker in Enum.map(rel["no_damage_from"], & &1["name"]) -> 0.0
                      true -> 1.0
                    end
                  end

                acc * mult_for_pt
              end)

            {attacker, mult}
          end)
          |> Enum.into(%{})

        # fraquezas: mult == 2.0 (x2) ou 4.0 (x4)
        fraqueza_x2 =
          defensivos_map
          |> Enum.filter(fn {_k, v} -> v == 2.0 end)
          |> Enum.map(&elem(&1, 0))
          |> Enum.map(&capitalize_type/1)

        fraqueza_x4 =
          defensivos_map
          |> Enum.filter(fn {_k, v} -> v == 4.0 end)
          |> Enum.map(&elem(&1, 0))
          |> Enum.map(&capitalize_type/1)

        # resistências: mult == 0.5 (x0.5) ou 0.25 (x0.25)
        resistencia_x05 =
          defensivos_map
          |> Enum.filter(fn {_k, v} -> v == 0.5 end)
          |> Enum.map(&elem(&1, 0))
          |> Enum.map(&capitalize_type/1)

        resistencia_x025 =
          defensivos_map
          |> Enum.filter(fn {_k, v} -> v == 0.25 end)
          |> Enum.map(&elem(&1, 0))
          |> Enum.map(&capitalize_type/1)

        nome = String.capitalize(p["name"])

        # monta mensagem com quebras de linha (PT-BR nos rótulos)
        msg = """
        Resistências #{nome}:
        x0.5 - #{format_list_or_none(resistencia_x05)}
        x0.25 - #{format_list_or_none(resistencia_x025)}

        Fraquezas #{nome}:
        x2 - #{format_list_or_none(fraqueza_x2)}
        x4 - #{format_list_or_none(fraqueza_x4)}
        """

        Message.create(channel_id, msg)

      {:error, :not_found} ->
        Message.create(channel_id, "Pokémon não encontrado.")
      {:error, reason} ->
        Message.create(channel_id, "Erro: #{inspect(reason)}")
    end
  end

  # ------------------------
  # Helpers
  # ------------------------
  defp format_list_or_none([]), do: "—"
  defp format_list_or_none(list), do: Enum.join(list, ", ")

  defp capitalize_type(type) when is_binary(type) do
    String.capitalize(type)
  end

  defp get_pokemon(name) do
    fetch_json("#{@base}/pokemon/#{URI.encode(name)}")
  end

  defp fetch_types_map(type_names) when is_list(type_names) do
    type_names
    |> Enum.uniq()
    |> Enum.reduce(%{}, fn t, acc ->
      case fetch_json("#{@base}/type/#{URI.encode(t)}") do
        {:ok, json} -> Map.put(acc, t, json)
        {:error, _} -> acc
      end
    end)
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

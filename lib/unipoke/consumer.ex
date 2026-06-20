
defmodule Unipoke.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Struct.Message, as: Msg
  alias Unipoke.Commands

  @impl true
  def handle_event({:MESSAGE_CREATE, %Msg{} = msg, _ws_state}) do
    if msg.author.bot do
      :noop
    else
      process_message(msg)
    end
  end

  def handle_event(_), do: :noop

  defp process_message(%Msg{content: content, channel_id: channel_id}) do
    content = String.trim(content)

    if String.starts_with?(content, "!") do
      Commands.handle_command(content, channel_id)
    else
      :noop
    end
  end
end

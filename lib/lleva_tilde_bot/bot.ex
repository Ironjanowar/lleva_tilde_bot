defmodule LlevaTildeBot.Bot do
  @bot :lleva_tilde_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start", description: "Says hi!")
  command("help", description: "Print the bot's help")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Here is your help:")
  end

  def handle({:text, text, _msg}, context) do
    {message, opts} = LlevaTildeBot.get_word(text)
    answer(context, message, opts)
  end
end

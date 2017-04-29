defmodule PubSub do

  alias PubSub.Link        , as: Link
  alias PubSub.Server      , as: Server
  alias PubSub.Subscriber  , as: Subscriber
  alias PubSub.Publisher   , as: Publisher
  alias PubSub.Chronometer , as: Chronometer

  @initial_topic "first"
  @starter :starter

  def init(pub_nr, sub_nr) do
    init_subscribers(sub_nr)
    |> init_server()
    init_chronometer()
    publishers = init_publishers(pub_nr)
    init_starter(publishers)
  end

  def start() do
    send @starter, :start
  end

  defp init_starter(publishers) do
    spawn_link(Starter, :run, [publishers])
    |> Process.register(@starter)
  end

  defp init_server(subscribers) do
    topic = String.to_atom(@initial_topic)
    spawn_link(Server, :run, [Keyword.put_new([], topic, subscribers)])
    |> Link.register_server
  end

  defp init_subscribers(nr) do
    for id <- 1..nr do
      spawn_link(Subscriber, :run, [id])
    end
  end

  defp init_publishers(nr) do
    for id <- 1..nr do
      spawn_link(Publisher, :run, [id, @initial_topic])
    end
  end

  defp init_chronometer() do
    spawn_link(Chronometer, :run, [])
    |> Link.register_chronometer
  end
end

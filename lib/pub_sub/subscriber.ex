defmodule PubSub.Subscriber do

  alias PubSub.Link, as: Link

  def run(id) do
    receive do
      {:new_topic, topicName}                  -> subscribe(topicName)
      {:new_content, topicName, content, node} -> consume(topicName, content, node)
    end
    run(id)
  end

  defp subscribe(topicName) do
    Link.subscribe(topicName, self())
  end

  defp consume(_topicName, _content, node) do
    Link.consumed(node)
  end

end

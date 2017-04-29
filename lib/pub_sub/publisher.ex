defmodule PubSub.Publisher do

  alias PubSub.Link, as: Link

  def run(_id, topicName) do
    receive do
      :publish -> publish(topicName, 1)
    end
  end

  defp publish(topicName, content) do
    Link.produced(self(), topicName)
    receive do
      {:ok, node} -> Link.publish(topicName, content, node)
    end
    #Process.sleep(5000)
    publish(topicName, content + 1)
  end

end

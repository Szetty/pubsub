defmodule PubSub.Server do

  alias PubSub.Link, as: Link

  def run(topics) do
    # {:messages, messages} = Process.info(self(), :messages)
    #count = Enum.count(messages)
    #if(count > 10) do
    #  IO.puts count
      #handle_more_publishes(messages)
    #end
    receive do
      {:register, topicName}                  -> register(topics, topicName)
      {:publish, topicName, content, node}    -> publish(topics, topicName, content, node)
      {:subscribe, topicName, subscriber}     -> subscribe(topics, topicName, subscriber)
      {:produced, producer, topicName}        -> produced(topics, producer, topicName)
    end
    |> run
  end

  defp handle_more_messages(messages) do
    nr_receives = Enum.count(messages, fn message ->
      case message do
        {:publish, _, _, _} -> true
        _ -> false
      end
    end)
    IO.puts nr_receives
    #for i<-1..nr_receives do
    #  receive do
    #    {:publish, topicName, content, node} 
    #  end
    #end
  end

  defp register(topics, topicName) do
    new_topic = {String.to_atom(topicName), []}
    [new_topic | topics]
  end

  defp publish(topics, topicName, content, node) do
    subscribers = topics[String.to_atom(topicName)]
    Enum.each(subscribers, fn(subscriber) ->
      Link.new_content(subscriber, topicName, content, node)
    end)
    topics
  end

  defp subscribe(topics, topicName, subscriber) do
    Keyword.update!(topics, String.to_atom(topicName), fn(subscribers) ->
      [subscriber | subscribers]
    end)
  end

  defp produced(topics, producer, topicName) do
    sub_nr = Enum.count(topics[String.to_atom(topicName)])
    Link.start_chronometer(producer, sub_nr)
    topics
  end

end

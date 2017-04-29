defmodule PubSub.Link do

  @server      :server
  @chronometer :chronometer

  #Called by PubSub
  def new_topic(subscriber, topic) do
    send subscriber, {:new_topic, topic}
  end

  #Called by PubSub
  def register_server(server_pid) do
    register_process(server_pid, @server)
  end

  #Called by PubSub
  def register_chronometer(chronometer_pid) do
    register_process(chronometer_pid, @chronometer)
  end

  #Called by PubSub
  def start_publishing(publisher) do
    send publisher, :publish
  end

  #Called by subscriber
  def subscribe(topicName, subscriber) do
    send @server, {:subscribe, topicName, subscriber}
  end

  #Called by PubSub
  def register_topic(topicName) do
    send @server, {:register, topicName}
  end

  #Called by Publisher
  def publish(topicName, content, node) do
    send @server, {
      :publish,
      topicName,
      content,
      node
    }
  end

  #Called by Publisher
  def produced(producer, topicName) do
    send :server, {
      :produced,
      producer,
      topicName
    }
  end

  #Called by Server
  def start_chronometer(producer, max_msg_nr) do
    send :chronometer, {
      :start,
      producer,
      {DateTime.utc_now |> DateTime.to_unix(:microseconds), max_msg_nr}
    }
  end

  #Called by Subscriber
  def consumed(node) do
    send node, {
      :record,
      DateTime.utc_now |> DateTime.to_unix(:microseconds)
    }
  end

  #Called by Server
  def new_content(subscriber, topicName, content, node) do
    send subscriber, {
      :new_content,
      topicName,
      content,
      node
    }
  end

  #Called by Chronometer
  def ack_to(producer, node) do
    send producer, {
      :ok,
      node
    }
  end

  defp register_process(pid, name) do
    Process.register(pid, name)
  end

end

defmodule PubSub.Chronometer do

  alias PubSub.Link, as: Link

  def run() do
    receive do
      {:start, starter, parameters} -> start(starter, parameters)
      message                       -> process_wrong_message(message)
    end
    run()
  end

  defp start(starter, {time, max_msg_nr}) do
    node_pid = spawn_link(PubSub.Chronometer.Node, :run, [{time, max_msg_nr}])
    Link.ack_to(starter, node_pid)
  end

  defp process_wrong_message(message) do
    IO.puts("Wrong message #{message}!!!")
  end
end

defmodule PubSub.Chronometer.Node do

  def run({start_time, max_msg_nr}) do
    run({0, 0}, {start_time, max_msg_nr})
  end

  def run(progress, constants) do
    receive do
      {:record, time} -> record(progress, time, constants)
      message -> IO.puts "PubSub.Chronometer.Node: wrong message #{message}"
    end
    |> decide_if_done(constants)
  end

  defp decide_if_done(progress, constants) do
    if(progress) do
      run(progress, constants)
    end
  end

  defp record({max_time, msg_nr}, time, {start_time, max_msg_nr}) do
    max_time = max(time, max_time)
    msg_nr = msg_nr + 1
    if(msg_nr == max_msg_nr) do
      process_time(start_time, max_time)
      nil
    else
      {max_time, msg_nr}
    end
  end

  defp process_time(start_time, max_time) do
    file = File.open!('log', [:append])
    IO.puts(file, "#{max_time - start_time}")
  end

end

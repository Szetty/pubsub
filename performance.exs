list = File.open!('log', [:read])
|> IO.read(:all)
|> String.split("\n", trim: true)
|> Enum.map(fn value -> String.to_integer(value) end)
average = Enum.sum(list)/Enum.count(list)
variances = Enum.map(list, fn value -> (value - average)*(value - average) end)
std_dev = Enum.sum(variances)/Enum.count(variances)
|> :math.sqrt
IO.puts "Count is:           #{Enum.count(list)}"
IO.puts "Average is:         #{average}"
IO.puts "Standard deviation: #{std_dev}"

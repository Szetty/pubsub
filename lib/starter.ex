defmodule Starter do

  alias PubSub.Link, as: Link

  def run(publishers) do
    receive do
      :start ->
        Enum.each(
          publishers,
          fn publisher -> Link.start_publishing(publisher) end
        )
    end
  end

end

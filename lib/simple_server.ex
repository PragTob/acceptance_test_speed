# Graciously stolen/adapted from Wallaby:
# https://github.com/keathley/wallaby/blob/master/test/support/test_server.ex
# MIT licensed
defmodule SimpleServer do
  @config [ port: 0,
            server_root:   String.to_char_list(Path.absname("./", __DIR__)),
            document_root: String.to_char_list(Path.absname("./pages", __DIR__)),
            server_name:   'simple_test',
            directory_index: ['index.html']]

  defstruct [:base_url, :pid]

  def start do
    :inets.start
    case :inets.start(:httpd, @config) do
      {:ok, pid} ->
        port = :httpd.info(pid)[:port]
        {:ok, %SimpleServer{base_url: "http://localhost:#{port}/", pid: pid}}
      error -> error
    end
  end

  def port(%SimpleServer{pid: pid}) do
    :httpd.info(pid)[:port]
  end

  def stop(%SimpleServer{pid: pid}) do
    :ok = :inets.stop(:httpd, pid)
  end
end

defmodule LlevaTildeBot.Scraper.Client do
  @base_url "https://llevatilde.es"

  def get_word(word) do
    url = "#{@base_url}/palabra/#{URI.encode(word, &URI.char_unreserved?/1)}"

    case Req.get(url, redirect: true, max_redirects: 3) do
      {:ok, %Req.Response{status: status, body: html}}
      when status in 200..299 and is_binary(html) ->
        {:ok, html}

      _response ->
        :error
    end
  end
end

require 'httparty'

class FedoraPaste::Creator
  def create(text)
    raise FedoraPaste::NoPasteText if text.strip.empty?
    response = HTTParty.post("http://paste.fedoraproject.org/").parsed_response
    id = response["result"]["id"]
    "http://paste.fedoraproject.org/#{id}"
  end
end

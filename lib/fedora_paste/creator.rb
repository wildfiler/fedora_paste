require 'httparty'

class FedoraPaste::Creator
  def create(text)
    raise FedoraPaste::NoPasteText if text.strip.empty?
    response = HTTParty.post("http://paste.fedoraproject.org/",
                        body: {
                          api_submit: 'true',
                          mode: 'json',
                          paste_data: text,
                          paste_lang: 'text'
                        } ).parsed_response
    responed_object = JSON.load(response)
    id = responed_object["result"]["id"]
    "http://paste.fedoraproject.org/#{id}"
  end
end

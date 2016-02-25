require 'spec_helper'

describe FedoraPaste::Creator do
  before do
    stub_request(:post, "http://paste.fedoraproject.org/").
      to_return(
        {
          status: 200,
          headers: { 'content_type': 'text/html; charset=UTF-8' },
          body: '{"result":{"id":1234}}'
        },
        {
          status: 200,
          headers: { 'content_type': 'text/html; charset=UTF-8' },
          body: '{"result":{"id":1235}}'
        },
      )
  end

  describe '#create' do
    it 'returns url to created paste' do
      creator = FedoraPaste::Creator.new

      result = creator.create('Some paste')

      expect(result).to eq 'http://paste.fedoraproject.org/1234'
    end

    it 'returns different url' do
      creator = FedoraPaste::Creator.new
      result1 = creator.create('paste1')
      result2 = creator.create('paste2')

      expect(result1).to_not eq(result2)
    end

    it 'send post request to fedora paste app' do
      creator = FedoraPaste::Creator.new

      creator.create('Some paste')

      expect(a_request(:post, 'http://paste.fedoraproject.org/')).to have_been_made
    end

    it 'sends post request with mandatory params' do
      creator = FedoraPaste::Creator.new

      creator.create('Some paste')

      body = {
        api_submit: 'true',
        mode: 'json',
        paste_data: 'Some paste',
        paste_lang: 'text',
      }
      request = a_request(:post, 'http://paste.fedoraproject.org/').with(body: body)
      expect(request).to have_been_made
    end

    context 'empty paste text' do
      it 'raises NoPasteText exception' do
        creator = FedoraPaste::Creator.new

        expect { creator.create('') }.to raise_error(FedoraPaste::NoPasteText)
      end

      it 'raises NoPasteText if text contains only whitespaces' do
        creator = FedoraPaste::Creator.new

        expect{creator.create('     ')}.to raise_error(FedoraPaste::NoPasteText)
      end
    end
  end
end

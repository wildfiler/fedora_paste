require 'spec_helper'

describe FedoraPaste::Creator do
  before do
    stub_request(:post, "http://paste.fedoraproject.org/").
      to_return(
        {
          status: 200,
          headers: { 'content_type': 'application/json'},
          body: '{"result":{"id":1234}}'
        },
        {
          status: 200,
          headers: { 'content_type': 'application/json'},
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
      allow(HTTParty).to receive(:post).and_call_original

      creator.create('Some paste')

      expect(HTTParty).to have_received(:post).with('http://paste.fedoraproject.org/')
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

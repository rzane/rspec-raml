RSpec.shared_examples 'when raml is not found' do
  context 'when raml is not found' do
    let(:_raml_finder) { double find_response: nil }

    describe '#matches?' do
      it 'handles nil' do
        expect(matcher.matches?(build_response)).to be(false)
      end
    end

    describe '#failure_message' do
      it 'handles a nil matcher' do
        matcher.matches?(build_response)
        expect(matcher.failure_message).to match(/not found/)
      end
    end
  end
end

RSpec.shared_examples 'when the body does not match' do
  let(:bad_request) { build_response(body: { id: 2 }.to_json) }

  describe '#matches?' do
    it 'rejects incorrect body' do
      expect(matcher.matches?(bad_request)).to be(false)
    end
  end

  describe '#failure_message' do
    it 'has a failure message' do
      matcher.matches?(bad_request)
      expect(matcher.failure_message).to match(/expected response bodies to match/)
    end
  end
end

RSpec.shared_examples 'when a status does not match' do
  let(:bad_request) { build_response(status: 400) }

  describe '#matches?' do
    it 'rejects incorrect status code' do
      expect(matcher.matches?(bad_request)).to be(false)
    end
  end

  describe '#failure_message' do
    it 'has a failure message' do
      matcher.matches?(bad_request)
      expect(matcher.failure_message).to match(/have a 200 status code, but got 400/)
    end
  end
end

RSpec.shared_examples 'when the content type does not match' do
  let(:bad_request) { build_response(content_type: 'text/plain') }

  describe '#matches?' do
    it 'rejects incorrect content type' do
      expect(matcher.matches?(bad_request)).to be(false)
    end
  end

  describe '#failure_message' do
    it 'has a failure message' do
      matcher.matches?(bad_request)
      expect(matcher.failure_message).to match(/content type: text\/plain/)
    end
  end
end

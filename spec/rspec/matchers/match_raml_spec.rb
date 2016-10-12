require 'spec_helper'
require_relative 'shared_examples'

RSpec.describe RSpec::Raml::Matchers::MatchRaml do
  raml { file_fixture('example.raml') }
  let(:request) { build_response }
  let(:matcher) { match_raml(:get, '/users/{id}', 200) }

  it 'validates the entire response' do
    expect(request).to matcher
  end

  include_examples 'when raml is not found'
  it_behaves_like 'when a status does not match'
  it_behaves_like 'when the body does not match'
  it_behaves_like 'when the content type does not match'
end

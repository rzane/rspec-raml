require 'spec_helper'
require_relative 'shared_examples'

RSpec.describe RSpec::Raml::Matchers::MatchRamlStatus do
  raml { file_fixture('example.raml') }
  let(:request) { build_response }
  let(:matcher) { match_raml_status(:get, '/users/{id}', 200) }

  it 'validates the status code' do
    expect(request).to matcher
  end

  include_examples 'when raml is not found'
  include_examples 'when a status does not match'
end

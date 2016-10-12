require 'spec_helper'
require_relative 'shared_examples'

RSpec.describe RSpec::Raml::Matchers::MatchRamlBody do
  raml { file_fixture('example.raml') }
  let(:request) { build_response }
  let(:matcher) { match_raml_body(:get, '/users/{id}', 200) }

  it 'validates the response body' do
    expect(request).to matcher
  end

  include_examples 'when raml is not found'
  include_examples 'when the body does not match'
end

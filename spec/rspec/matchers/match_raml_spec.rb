require 'spec_helper'
require_relative 'shared_examples'

RSpec.describe RSpec::Raml::Matchers::MatchRaml do
  raml { file_fixture('example.raml') }

  context 'a simple request' do
    subject { build_response }
    specify { is_expected.to match_raml(:get, '/users/{id}', 200) }
  end

  context 'with sub-matcher arguments' do
    subject {
      build_response(
        body: {
          id: 2,
          first_name: 'John',
          last_name: 'Doe'
        }.to_json
      )
    }

    specify { is_expected.to match_raml(:get, '/users/{id}', 200).except(:id) }
  end

  context 'failure' do
    let(:matcher) { match_raml(:get, '/users/{id}', 200) }

    include_examples 'when raml is not found'
    it_behaves_like 'when a status does not match'
    it_behaves_like 'when the body does not match'
    it_behaves_like 'when the content type does not match'
  end
end

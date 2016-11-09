require 'spec_helper'
require_relative 'shared_examples'

RSpec.describe RSpec::Raml::Matchers::MatchRamlBody do
  raml { file_fixture('example.raml') }

  context 'with a simple match' do
    subject { build_response }
    specify {
      is_expected.to match_raml_body(:get, '/users/{id}', 200)
    }
  end

  context 'with a exception match' do
    subject {
      build_response(
        body: {
          id: 2,
          first_name: 'John',
          last_name: 'Doe'
        }.to_json
      )
    }

    specify {
      is_expected.to match_raml_body(:get, '/users/{id}', 200).except(:id)
    }
  end

  context 'failures' do
    let(:matcher) { match_raml_body(:get, '/users/{id}', 200) }
    include_examples 'when raml is not found'
    include_examples 'when the body does not match'
  end
end

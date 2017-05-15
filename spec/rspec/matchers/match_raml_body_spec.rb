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
      is_expected.to match_raml_body(:get, '/users/{id}', 200).exclude(:id)
    }
  end

  context 'failures' do
    let(:matcher) { match_raml_body(:get, '/users/{id}', 200) }
    include_examples 'when raml is not found'
    include_examples 'when the body does not match'
  end

  context 'with nested excludes' do
    subject { build_response(body: body.to_json) }

    let(:body) {
      {
        id: 5,
        title: 'Fun',
        author: {
          name: 'Jeff',
          age: 12
        },
        awards: [
          {
            id: 18,
            name: 'Emmy'
          }
        ]
      }
    }

    specify {
      is_expected.to match_raml_body(:get, '/posts/{id}', 200).exclude(
        :id,
        author: :name,
        awards: [:id]
      )
    }
  end
end

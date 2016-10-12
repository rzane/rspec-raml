require 'spec_helper'
require_relative 'shared_examples'

RSpec.describe RSpec::Raml::Matchers::BeRamlContentType do
  raml { file_fixture('example.raml') }
  let(:request) { build_response }
  let(:matcher) { be_raml_content_type(:get, '/users/{id}', 200) }

  it 'validates the content type' do
    expect(request).to matcher
  end

  include_examples 'when raml is not found'
  include_examples 'when the content type does not match'
end

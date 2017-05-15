$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rspec/raml'
require 'pry'

module Helpers
  def file_fixture(filename)
    Pathname.new(File.expand_path('../fixtures', __FILE__)).join(filename)
  end

  def build_response(overrides = {})
    defaults = {
      status: 200,
      content_type: 'application/json',
      body: { id: 1, first_name: 'John', last_name: 'Doe' }.to_json
    }

    double(defaults.merge(overrides))
  end
end

RSpec.configure do |config|
  config.color = true
  config.include Helpers
  config.include RSpec::Raml::Matchers
end

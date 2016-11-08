require 'rspec/raml/matchers/abstract'

module RSpec
  module Raml
    module Matchers
      class NullMatcher < Abstract
        def initialize(verb, url, status)
          super(nil, verb, url, status)
        end

        def failure_message
          "RAML not found. Here's something to get you started:\n\n#{template}"
        end

        private

        def matches_raml?
          false
        end

        def template
          {
            url => {
              displayName: 'PENDING NAME',
              verb => {
                responses: {
                  status => {
                    description: 'PENDING DESCRIPTION',
                    body: {
                      response.content_type => {
                        example: pretty_format(response.body)
                      }
                    }
                  }
                }
              }
            }
          }.deep_stringify_keys.to_yaml
        end

        def pretty_format(body)
          JSON.pretty_generate JSON.parse(body)
        end
      end
    end
  end
end

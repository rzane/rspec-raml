require 'rspec/raml/matchers/abstract'

module RSpec
  module Raml
    module Matchers
      class MatchRamlStatus < Abstract
        def description
          'match RAML status'
        end

        def failure_message
          "expected the response to have a #{raml.code} status code, but got #{response.status}"
        end

        def failure_message_when_negated
          "expected the response not to have status: #{raml.code}"
        end

        private

        def matches_raml?
          response.status == raml.code
        end
      end
    end
  end
end

require 'rspec/raml/matchers/abstract'

module RSpec
  module Raml
    module Matchers
      class MatchRamlBody < Abstract
        def failure_message
          diff = differ.diff_as_string(response_body, raml_body)
          "expected response bodies to match:#{diff}"
        end

        def failure_message_when_negated
          "expected response bodies not to match"
        end

        private

        def matches_raml?
          response_body == raml_body
        end

        def response_body
          @response_body ||= indent_pretty_format(response.body)
        end

        def raml_body
          @raml_body ||= indent_pretty_format(raml.bodies.fetch(content_type).example)
        end

        def differ
          @differ ||= RSpec::Support::Differ.new(color: true)
        end

        def indent_pretty_format(body)
          pretty_format(body).gsub("\n", "\n  ").prepend('  ')
        end
      end
    end
  end
end
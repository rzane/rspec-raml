require 'rspec/raml/matchers/abstract'

module RSpec
  module Raml
    module Matchers
      class MatchRamlBody < Abstract
        def initialize(*)
          super
          @except = []
        end

        def description
          'match RAML body'
        end

        def except(*keys)
          @except |= keys.map(&:to_s)
          self
        end

        def failure_message
          diff = differ.diff_as_object(
            response_body,
            raml_body
          )

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
          @response_body ||= comparable(response.body)
        end

        def raml_body
          @raml_body ||= comparable(raml.bodies.fetch(content_type).example)
        end

        def differ
          @differ ||= RSpec::Support::Differ.new(color: true)
        end

        def comparable(body)
          remove_exceptions JSON.parse(body)
        end

        def remove_exceptions(data)
          case data
          when Array
            data.map { |item| remove_exceptions(item) }
          when Hash
            data.slice(*(data.keys - @except))
          else
            data
          end
        end
      end
    end
  end
end

require 'rspec/raml/matchers/abstract'

module RSpec
  module Raml
    module Matchers
      class BeRamlContentType < Abstract
        def failure_message
          "expected RAML to declare a response for content type: #{content_type}"
        end

        def failure_message_when_negated
          "expected RAML not to declare content type: #{content_type}"
        end

        private

        def matches_raml?
          raml.bodies.key? content_type
        end
      end
    end
  end
end

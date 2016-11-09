require 'rspec/raml/matchers/abstract'

module RSpec
  module Raml
    module Matchers
      class MatchRaml < Abstract
        delegate :failure_message, :failure_message_when_negated, to: :failure

        def description
          'match RAML'
        end

        private

        def matches_raml?
          failure.nil?
        end

        def failure
          @failure ||= matchers.find { |m| !m.matches?(response) }
        end

        def matchers
          (RSpec::Raml::Matchers::MATCHERS - [self.class]).map do |matcher|
            matcher.new(raml, verb, url, status)
          end
        end
      end
    end
  end
end

require 'rspec/raml/exclusion_filter'
require 'rspec/raml/matchers/abstract'

module RSpec
  module Raml
    module Matchers
      class MatchRamlBody < Abstract
        def initialize(*)
          super
          @excludes = []
          @differ   = RSpec::Support::Differ.new(color: true)
        end

        def description
          'match RAML body'
        end

        def exclude(*values)
          @excludes += values
          self
        end
        alias except exclude

        def failure_message
          diff = @differ.diff_as_object(actual, expected)
          "expected response bodies to match:#{diff}"
        end

        def failure_message_when_negated
          "expected response bodies not to match"
        end

        private

        def matches_raml?
          RSpec::Support::FuzzyMatcher.values_match?(expected, actual)
        end

        def actual
          @actual ||= JSON.parse(response.body)
        end

        def expected
          @expected ||= begin
            example = raml.bodies.fetch(content_type).example
            exclusion_filter.filter JSON.parse(example)
          end
        end

        def exclusion_filter
          ExclusionFilter.new(@excludes)
        end
      end
    end
  end
end

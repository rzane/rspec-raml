require 'rspec/raml/matchers/abstract'
require 'active_support/core_ext/module/delegation'

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
          @matchers ||= (RSpec::Raml::Matchers::MATCHERS - [self.class]).map do |matcher|
            matcher.new(raml, verb, url, status)
          end
        end

        def respond_to_missing?(meth, *)
          matchers.any? { |m| m.respond_to?(meth) } || super
        end

        def method_missing(meth, *args, &block)
          valid = matchers.any? do |matcher|
            if matcher.respond_to?(meth)
              matcher.send(meth, *args, &block)
              true
            end
          end

          valid ? self : super
        end
      end
    end
  end
end

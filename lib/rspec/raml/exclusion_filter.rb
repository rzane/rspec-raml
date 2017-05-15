module RSpec
  module Raml
    class ExclusionFilter
      ANYTHING = RSpec::Mocks::ArgumentMatchers::AnyArgMatcher::INSTANCE

      def initialize(excludes)
        @excludes = excludes
      end

      def filter(object)
        @excludes.reduce object do |acc, exclude|
          replace(acc, exclude)
        end
      end

      private

      def replace(body, exclude)
        case exclude
        when Hash
          replace_hash(body, exclude)
        when Array
          replace_array(body, exclude)
        when Symbol, String
          body.merge(exclude.to_s => ANYTHING)
        else
          body
        end
      end

      def replace_hash(body, exclude)
        exclude.reduce(body) do |acc, (k, v)|
          acc.merge(k.to_s => replace(acc[k.to_s], v))
        end
      end

      def replace_array(body, exclude)
        case body
        when Array
          body.map { |item| replace(item, exclude) }
        when Hash
          exclude.reduce(body) { |acc, key| replace(acc, key) }
        else
          body
        end
      end
    end
  end
end

require 'raml'

module RSpec
  module Raml
    class Finder
      attr_reader :raml

      def initialize(raml)
        @raml = raml
      end

      # Recursively traverses the raml structure and locates all resources
      # with a matching url.
      def find_resources(path, node: raml)
        node.resources.flat_map do |resource|
          children = find_resources(path, node: resource)

          if resource.path == path
            children + [resource]
          else
            children
          end
        end
      end

      # Finds the response that matches the verb, path, and status.
      def find_response(verb, path, status)
        find_resources(path)
          .lazy
          .flat_map(&:http_methods)
          .select { |m| m.method == verb.to_s }
          .flat_map(&:responses)
          .select { |r| r.code == status }
          .first
      end
    end
  end
end

require 'raml'

module RSpec
  module Raml
    class Finder
      attr_reader :raml

      def initialize(raml)
        @raml = raml
      end

      # Recursively traverses the raml structure and locates all Raml::Resources
      # with a matching url.
      def find_resources(path, node = raml)
        node.children.flat_map do |child|
          if child.kind_of?(::Raml::Resource) && child.resource_path == path
            child
          elsif child.respond_to?(:children)
            find_resources(path, child)
          else
            []
          end
        end
      end

      # Finds the response that matches the verb, path, and status.
      def find_response(verb, path, status)
        resources = find_resources(path)

        resource = resources.find do |node|
          method = node.methods[verb.to_s]
          method && method.responses[status]
        end

        http_method = resource && resource.methods[verb.to_s]
        http_method.responses[status] if http_method
      end
    end
  end
end

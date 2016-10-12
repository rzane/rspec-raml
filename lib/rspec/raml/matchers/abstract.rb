require 'json'
require 'yaml'

module RSpec
  module Raml
    module Matchers
      class Abstract
        attr_reader :raml, :verb, :url, :status, :response

        def initialize(raml, verb, url, status)
          @raml = raml
          @verb = verb
          @url = url
          @status = status
        end

        def matches?(response)
          @response = response
          matches_raml?
        end

        private

        def content_type
          response.content_type.to_s
        end

        def pretty_format(body)
          JSON.pretty_generate(JSON.parse(body))
        end
      end
    end
  end
end

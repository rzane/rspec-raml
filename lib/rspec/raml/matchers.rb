require 'raml-rb'
require 'active_support/core_ext/string'
require 'rspec/raml/finder'
require 'rspec/raml/matchers/null_matcher'
require 'rspec/raml/matchers/match_raml'
require 'rspec/raml/matchers/match_raml_body'
require 'rspec/raml/matchers/match_raml_status'
require 'rspec/raml/matchers/be_raml_content_type'

module RSpec
  module Raml
    module Matchers
      MATCHERS = [
        MatchRaml,
        MatchRamlStatus,
        BeRamlContentType,
        MatchRamlBody
      ]

      def self.included(base)
        base.extend ClassMethods
        base.let(:_raml_finder) do
          raise ArgumentError, <<-EOMSG.strip_heredoc
            You need to specify a RAML specification file. Example:

              raml { Rails.root.join('docs/api/v1.raml') }
          EOMSG
        end
      end

      module ClassMethods
        def raml(&block)
          let(:_raml_file, &block)
          let(:_raml_finder) do
            RSpec::Raml::Finder.new(::Raml::Parser.parse_file(_raml_file))
          end
        end
      end

      # Generate matcher methods:
      #
      # + def match_raml(verb, url, status)
      # + def match_raml_status(verb, url, status)
      # + def match_raml_body(verb, url, status)
      # + def be_raml_content_type(verb, url, status)
      #
      MATCHERS.each do |matcher|
        define_method matcher.name.split('::').last.underscore do |verb, url, status|
          if raml = _raml_finder.find_response(verb, url, status)
            matcher.new(raml, verb, url, status)
          else
            NullMatcher.new(verb, url, status)
          end
        end
      end
    end
  end
end

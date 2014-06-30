require 'pathname'
require 'smartdown/model/flow'
require 'smartdown/model/node'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_transform'

module Smartdown
  module Parser
    class NodeInterpreter
      attr_reader :name, :source

      def initialize(name, source, options = {})
        @name = name
        @source = source
        @parser = options.fetch(:parser, Smartdown::Parser::NodeParser.new)
        @transform = options.fetch(:transform, Smartdown::Parser::NodeTransform.new)
      end

      def interpret
        transform.apply(parser.parse(source),
          node_name: name
        )
      end

    private
      attr_reader :parser, :transform
    end
  end
end

require 'pathname'
require 'smartdown/model/flow'
require 'smartdown/model/node'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_transform'

module Smartdown
  module Parser
    class NodeInterpreter
      attr_reader :name, :data

      def initialize(name, data)
        @name = name
        @data = data
      end

      def interpret
        transform.apply(parser.parse(data),
          node_name: name
        )
      end

    private
      def parser
        Smartdown::Parser::NodeParser.new
      end

      def transform
        Smartdown::Parser::NodeTransform.new
      end
    end
  end
end

require 'pathname'
require 'smartdown/model/flow'
require 'smartdown/model/node'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_transform'

module Smartdown
  module Parser
    class NodeInterpreter
      attr_reader :name, :source, :reporter

      def initialize(name, source, options = {})
        @name = name
        @source = source
        data_module = options.fetch(:data_module, {})
        @parser = options.fetch(:parser, Smartdown::Parser::NodeParser.new)
        @transform = options.fetch(:transform, Smartdown::Parser::NodeTransform.new(data_module))
        @reporter = options.fetch(:reporter, Parslet::ErrorReporter::Deepest.new)
      end

      def interpret
        transform.apply(parser.parse(source, reporter: reporter),
          node_name: name
        )
      end

    private
      attr_reader :parser, :transform
    end
  end
end

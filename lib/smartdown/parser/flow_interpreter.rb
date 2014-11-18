require 'smartdown/model/flow'
require 'smartdown/parser/node_interpreter'
require 'smartdown/parser/snippet_pre_parser'

module Smartdown
  module Parser
    class ParseError < StandardError
      attr_reader :filename, :parse_error

      def initialize(filename, parse_error)
        @filename = filename
        @parse_error = parse_error
      end

      def to_s(full = true)
        position = parse_error.cause.pos
        line, column = parse_error.cause.source.line_and_column(position)

        "Parse error in file:'#{filename}' line:'#{line}' column:'#{column}'" +
        "\n\n" + parse_error.cause.ascii_tree
      end
    end

    class FlowInterpreter
      attr_reader :flow_input, :data_module

      def initialize(flow_input, data_module=nil)
        @flow_input = pre_parse(flow_input)
        @data_module = data_module
      end

      def interpret
        Smartdown::Model::Flow.new(coversheet.name, [coversheet] + questions + outcomes)
      end

    private
      def coversheet
        interpret_node(flow_input.coversheet)
      end

      def questions
        flow_input.questions.map { |question_data| interpret_node(question_data) }
      end

      def outcomes
        flow_input.outcomes.map { |outcome_data| interpret_node(outcome_data) }
      end

      def interpret_node(input_data)
        Smartdown::Parser::NodeInterpreter.new(input_data.name, input_data.read, options).interpret
      rescue Parslet::ParseFailed => error
        raise ParseError.new(input_data.name, error)
      end

      def pre_parse(flow_input)
        SnippetPreParser.parse(flow_input)
      end

      def options
        {}.tap do |opts|
          opts[:data_module] = data_module if data_module
        end
      end
    end
  end
end

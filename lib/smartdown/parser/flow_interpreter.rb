require 'smartdown/model/flow'
require 'smartdown/parser/node_interpreter'

module Smartdown
  module Parser
    class FlowInterpreter
      attr_reader :flow_input

      def initialize(flow_input)
        @flow_input = flow_input
      end

      def interpret
        Smartdown::Model::Flow.new(coversheet.name, [coversheet] + questions)
      end

    private
      def coversheet
        interpret_node(flow_input.coversheet)
      end

      def questions
        flow_input.questions.map { |i| interpret_node(i) }
      end

      def interpret_node(input_data)
        Smartdown::Parser::NodeInterpreter.new(input_data.name, input_data.read).interpret
      end
    end
  end
end

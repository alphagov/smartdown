require 'smartdown/api/previous_question_page'

module Smartdown
  module Api
    class State

      attr_reader :responses, :current_node

      def initialize(current_node, previous_questionpage_smartdown_nodes, responses)
        @current_node = current_node
        @previous_questionpage_smartdown_nodes = previous_questionpage_smartdown_nodes
        @responses = responses
      end

      def started?
        !current_node.is_a? Smartdown::Api::Coversheet
      end

      def finished?
        current_node.is_a? Smartdown::Api::Outcome
      end

      def previous_question_pages(responses)
        previous_questionpage_smartdown_nodes.map do |smartdown_questionpage_node|
          Smartdown::Api::PreviousQuestionPage.new(smartdown_questionpage_node, responses)
        end
      end

      def current_question_number
        responses.count + 1
      end

    private

      attr_reader :smartdown_state, :previous_questionpage_smartdown_nodes

    end
  end
end

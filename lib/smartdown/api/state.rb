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

      def answers
        previous_question_pages(responses).map { |previous_question_page|
          previous_question_page.answers
        }.flatten
      end

      def previous_question_pages(responses)
        @previous_question_pages ||= build_question_pages(responses)
      end

      def started?
        !current_node.is_a? Smartdown::Api::Coversheet
      end

      def finished?
        current_node.is_a? Smartdown::Api::Outcome
      end

      def current_question_number
        responses.count + 1
      end

    private

      attr_reader :smartdown_state, :previous_questionpage_smartdown_nodes

      def build_question_pages(responses)
        resp = responses.dup
        previous_questionpage_smartdown_nodes.map do |smartdown_questionpage_node|
          page_questions = resp.take(smartdown_questionpage_node.questions.count)
          resp = resp.drop(smartdown_questionpage_node.questions.count)
          Smartdown::Api::PreviousQuestionPage.new(smartdown_questionpage_node, page_questions)
        end
      end
    end
  end
end

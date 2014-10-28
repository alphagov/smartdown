require 'smartdown/api/previous_question_page'

module Smartdown
  module Api
    class State

      attr_reader :accepted_responses, :current_node, :current_answers

      def initialize(current_node, previous_questionpage_smartdown_nodes, accepted_responses, current_answers)
        @current_node = current_node
        @previous_questionpage_smartdown_nodes = previous_questionpage_smartdown_nodes
        @accepted_responses = accepted_responses
        @current_answers = current_answers
      end

      def previous_answers
        previous_question_pages.map { |previous_question_page|
          previous_question_page.answers
        }.flatten
      end

      def previous_question_pages
        @previous_question_pages ||= build_question_pages(accepted_responses[1..-1])
      end

      def started?
        !current_node.is_a? Smartdown::Api::Coversheet
      end

      def finished?
        current_node.is_a? Smartdown::Api::Outcome
      end

      def current_question_number
        accepted_responses.count + 1
      end

    private

      attr_reader :previous_questionpage_smartdown_nodes

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

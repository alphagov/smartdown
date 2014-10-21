require 'smartdown/api/previous_question'

module Smartdown
  module Api
    class PreviousQuestionPage

      attr_reader :title

      def initialize(node, responses)
        node_elements = node.elements.clone
        headings = node_elements.select {
          |element| element.is_a? Smartdown::Model::Element::MarkdownHeading
        }
        nb_questions = node_elements.select{ |element|
          element.class.to_s.include?("Smartdown::Model::Element::Question")
        }.count
        if headings.count > nb_questions
          node_elements.delete(headings.first) #Remove page title
          @title = headings.first.content.to_s
        end
        @elements = node_elements
        @responses = responses
      end

      def answers
        questions.map(&:answer)
      end

      def questions
        @questions ||= elements.slice_before do |element|
          element.is_a? Smartdown::Model::Element::MarkdownHeading
        end.each_with_index.map do |question_element_group, index|
          Smartdown::Api::PreviousQuestion.new(question_element_group, responses[index])
        end
      end

      private

      attr_reader :elements, :responses
    end
  end
end

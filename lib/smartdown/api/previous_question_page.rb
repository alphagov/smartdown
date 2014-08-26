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
        @title = headings.first.content.to_s if headings.first
        nb_questions = node_elements.select{ |element|
          element.is_a? Smartdown::Model::Element::MultipleChoice
        }.count
        if headings.count > nb_questions
          node_elements.delete(headings.first) #Remove page title
        end
        @elements = node_elements
        @responses = responses
      end

      def questions
        elements.slice_before do |element|
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

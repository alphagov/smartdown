require 'smartdown/api/multiple_choice'

module Smartdown
  module Api
    class QuestionPage < Node
      def questions
        elements.slice_before do |element|
          element.is_a? Smartdown::Model::Element::MarkdownHeading
        end.each_with_index.map do |question_element_group, index|
          if question_element_group.find{|element| element.is_a? Smartdown::Model::Element::Question::MultipleChoice}
            Smartdown::Api::MultipleChoice.new(question_element_group, index+1)
          end
        end
      end
    end
  end
end

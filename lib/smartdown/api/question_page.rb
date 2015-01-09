require 'smartdown/api/multiple_choice'
require 'smartdown/api/date_question'
require 'smartdown/api/country_question'
require 'smartdown/api/salary_question'
require 'smartdown/api/text_question'
require 'smartdown/api/postcode_question'
require 'smartdown/api/money_question'

module Smartdown
  module Api
    class QuestionPage < Node
      def questions
        elements.slice_before do |element|
          element.is_a? Smartdown::Model::Element::MarkdownHeading
        end.map do |question_element_group|
          question, answer = Smartdown::Model::Element::Question.
              create_question_answer(question_element_group)
          question
        end.compact
      end
    end
  end
end

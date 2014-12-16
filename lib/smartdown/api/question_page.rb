require 'smartdown/api/multiple_choice'
require 'smartdown/api/date_question'
require 'smartdown/api/country_question'
require 'smartdown/api/salary_question'
require 'smartdown/api/text_question'
require 'smartdown/api/postcode_question'

module Smartdown
  module Api
    class QuestionPage < Node
      def questions
        elements.slice_before do |element|
          element.is_a? Smartdown::Model::Element::MarkdownHeading
        end.map do |question_element_group|
          if question_element_group.find{|element| element.is_a? Smartdown::Model::Element::Question::MultipleChoice }
            Smartdown::Api::MultipleChoice.new(question_element_group)
          elsif question_element_group.find{ |element| element.is_a?(Smartdown::Model::Element::Question::Country) }
            Smartdown::Api::CountryQuestion.new(question_element_group)
          elsif question_element_group.find{|element| element.is_a? Smartdown::Model::Element::Question::Date}
            Smartdown::Api::DateQuestion.new(question_element_group)
          elsif question_element_group.find{|element| element.is_a? Smartdown::Model::Element::Question::Salary}
            Smartdown::Api::SalaryQuestion.new(question_element_group)
          elsif question_element_group.find{|element| element.is_a? Smartdown::Model::Element::Question::Text}
            Smartdown::Api::TextQuestion.new(question_element_group)
          elsif question_element_group.find{|element| element.is_a? Smartdown::Model::Element::Question::Postcode}
            Smartdown::Api::PostcodeQuestion.new(question_element_group)
          end
        end
      end
    end
  end
end

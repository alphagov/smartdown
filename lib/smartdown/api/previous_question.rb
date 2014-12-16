module Smartdown
  module Api
    class PreviousQuestion
      extend Forwardable

      def_delegators :@question, :title, :options

      attr_reader :answer, :question

      def initialize(elements, response)
        if element = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::MultipleChoice}
          @question = MultipleChoice.new(elements)
        elsif element = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::Country}
          @question = CountryQuestion.new(elements)
        elsif element = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::Date}
          @question = DateQuestion.new(elements)
        elsif element = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::Salary}
          @question = SalaryQuestion.new(elements)
        elsif element = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::Text}
          @question = TextQuestion.new(elements)
        elsif element = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::Postcode}
          @question = PostcodeQuestion.new(elements)
        end
        @answer = element.answer_type.new(response, element) if element
      end

    end
  end
end

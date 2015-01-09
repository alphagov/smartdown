module Smartdown
  module Api
    class PreviousQuestion
      extend Forwardable

      def_delegators :@question, :title, :options

      attr_reader :answer, :question

      def initialize(elements, response)
        @question, @answer = Smartdown::Model::Element::Question.
            create_question_answer(elements, response)
      end

    end
  end
end

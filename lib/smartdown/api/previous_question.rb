module Smartdown
  module Api
    class PreviousQuestion
      extend Forwardable

      def_delegators :@question, :title, :options

      attr_reader :response

      def initialize(elements, response)
        @response = response
        if elements.find{|element| element.is_a? Smartdown::Model::Element::Question::MultipleChoice}
          @question = MultipleChoice.new(elements)
        end
      end

    end
  end
end

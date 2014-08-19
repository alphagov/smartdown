module Smartdown
  module Api
    class PreviousQuestion

      attr_reader :response, :title

      def initialize(title, question_element, response, modifiable)
        @title = title
        @question_element = question_element
        @response = response
        @modifiable = modifiable
      end

      #TODO: remove need for this method by impleemnting modification properly
      def modifiable?
        @modifiable
      end

      #TODO: to be moved to presenter
      def multiple_responses?
        false
      end

      #TODO: move to presenter, this object API should only expose question_element.choices
      def response_label(value=response)
        @question_element.choices.fetch(value)
      end

    end
  end
end

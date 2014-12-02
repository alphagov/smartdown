module Smartdown
  module Api
    class Outcome < Node

      def next_steps
        elements.find{|element| element.is_a? Smartdown::Model::Element::NextSteps}.content
      end

    end
  end
end

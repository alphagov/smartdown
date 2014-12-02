module Smartdown
  module Api
    class Outcome < Node

      def next_steps
        next_steps = elements.find{ |element| element.is_a? Smartdown::Model::Element::NextSteps}
        next_steps.content if next_steps && !next_steps.content.empty?
      end

    end
  end
end

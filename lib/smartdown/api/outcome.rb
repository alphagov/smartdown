module Smartdown
  module Api
    class Outcome < Node

      def next_steps
        next_step_element = elements.find{|element| element.is_a? Smartdown::Model::Element::NextSteps}
        Govspeak::Document.new(next_step_element.content).to_html.html_safe if next_step_element
      end

    end
  end
end

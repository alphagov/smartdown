require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class NextSteps < Base

        rule(:markdown) { (str("[end_next_steps]").absnt? >> any).repeat.as(:content) }

        rule(:next_steps_tag) {
          str("[next_steps]") >>
          optional_space >>
          line_ending
        }

        rule(:next_steps_end_tag) {
          str("[end_next_steps]") >>
          optional_space >>
          line_ending
        }

        rule(:next_steps) {
          (
            next_steps_tag >>
            markdown >>
            next_steps_end_tag
          ).as(:next_steps)
        }
        root(:next_steps)
      end
    end
  end
end

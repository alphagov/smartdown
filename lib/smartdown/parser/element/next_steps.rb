require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class NextSteps < Base
        rule(:next_steps_tag) {
          str("[next_steps]") >>
          optional_space >>
          line_ending
        }

        rule(:next_step_definition_line) {
          bullet >>
          optional_space >>
          identifier.as(:url) >>
          str(":") >>
          optional_space >>
          whitespace_terminated_string.as(:label) >>
          optional_space
        }

        rule(:next_steps) {
          (
            next_steps_tag >>
            (next_step_definition_line >> line_ending).repeat(1).as(:urls)
          ).as(:next_steps)
        }
        root(:next_steps)
      end
    end
  end
end

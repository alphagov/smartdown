require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class MultipleChoiceQuestion < Base
        rule(:option_definition_line) {
          bullet >>
            optional_space >>
            identifier.as(:value) >>
            str(":") >>
            optional_space >>
            whitespace_terminated_string.as(:label) >>
            optional_space
        }

        rule(:multiple_choice_question) {
          (option_definition_line >> line_ending).repeat(1).as(:multiple_choice)
        }
        root(:multiple_choice_question)
      end
    end
  end
end

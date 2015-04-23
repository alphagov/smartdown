require 'smartdown/parser/question'

module Smartdown
  module Parser
    module Element
      class MultipleOptionQuestion < Question
        rule(:question_type) {
          str("options")
        }

        rule(:option_definition_line) {
          bullet >>
            optional_space >>
            identifier.as(:value) >>
            str(":") >>
            optional_space >>
            whitespace_terminated_string.as(:label) >>
            optional_space
        }

        rule(:multiple_option_question) {
          (
            question_tag >>
            (option_definition_line >> line_ending).repeat(1).as(:options)
          ).as(:multiple_option)
        }
        root(:multiple_option_question)
      end
    end
  end
end

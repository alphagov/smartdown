require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class MultipleChoiceQuestion < Base
        rule(:multiple_choice_question_tag) {
          str("[choice:") >>
            optional_space >>
            question_identifier.as(:identifier) >>
            optional_space >>
            str("]") >>
            optional_space >>
            line_ending
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

        rule(:optional_hint) {
          str('[hint: ') >> (str("]").absnt? >> any).repeat.as(:hint) >> str(']') >> line_ending
        }

        rule(:multiple_choice_question) {
          (
            multiple_choice_question_tag >>
            optional_hint.maybe >>
            (option_definition_line >> line_ending).repeat(1).as(:options)
          ).as(:multiple_choice)
        }
        root(:multiple_choice_question)
      end
    end
  end
end

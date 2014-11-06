require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class TextQuestion < Base
        rule(:text_question) {
          (
          str("[text:") >>
              optional_space >>
              question_identifier.as(:identifier) >>
              optional_space >>
              option_pair.repeat.as(:option_pairs) >>
              str("]") >>
              optional_space >>
              line_ending
          ).as(:text)
        }
        root(:text_question)
      end
    end
  end
end

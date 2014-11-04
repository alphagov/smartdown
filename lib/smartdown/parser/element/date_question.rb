require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class DateQuestion < Base
        rule(:date_question) {
          (
          str("[date:") >>
              optional_space >>
              question_identifier.as(:identifier) >>
              optional_space >>
              option_pair.repeat.as(:option_pairs) >>
              str("]") >>
              optional_space >>
              line_ending
          ).as(:date)
        }
        root(:date_question)
      end
    end
  end
end

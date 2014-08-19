require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class DateQuestion < Base
        rule(:date) {
          ( str("[date:") >>
              optional_space >>
              question_identifier.as(:identifier) >>
              optional_space >>
              str("]") >>
              optional_space >>
              line_ending
          ).as(:date)
        }
        root(:date)
      end
    end
  end
end

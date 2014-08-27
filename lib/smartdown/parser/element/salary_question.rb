require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class SalaryQuestion < Base
        rule(:salary_question) {
          (
          str("[salary:") >>
              optional_space >>
              question_identifier.as(:identifier) >>
              optional_space >>
              str("]") >>
              optional_space >>
              line_ending
          ).as(:salary)
        }
        root(:salary_question)
      end
    end
  end
end

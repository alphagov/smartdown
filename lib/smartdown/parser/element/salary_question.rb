require 'smartdown/parser/base'
require 'smartdown/parser/question'

module Smartdown
  module Parser
    module Element
      class SalaryQuestion < Question
        rule(:question_type) {
          str("salary")
        }

        rule(:salary_question) {
          question_tag.as(:salary)
        }

        root(:salary_question)
      end
    end
  end
end

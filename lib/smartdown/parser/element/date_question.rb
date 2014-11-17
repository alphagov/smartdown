require 'smartdown/parser/base'
require 'smartdown/parser/question'

module Smartdown
  module Parser
    module Element
      class DateQuestion < Question
        rule(:question_type) {
          str("date")
        }

        rule(:date_question) {
          question_tag.as(:date)
        }

        root(:date_question)
      end
    end
  end
end

require 'smartdown/parser/base'
require 'smartdown/parser/question'

module Smartdown
  module Parser
    module Element
      class MoneyQuestion < Question
        rule(:question_type) {
          str("money")
        }

        rule(:money_question) {
          question_tag.as(:money)
        }

        root(:money_question)
      end
    end
  end
end

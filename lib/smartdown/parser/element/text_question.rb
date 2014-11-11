require 'smartdown/parser/question'

module Smartdown
  module Parser
    module Element
      class TextQuestion < Question

        rule(:question_type) {
          str("text")
        }

        rule(:text_question) {
          question_tag.as(:text)
        }

        root(:text_question)
      end
    end
  end
end

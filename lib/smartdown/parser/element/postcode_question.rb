require 'smartdown/parser/question'

module Smartdown
  module Parser
    module Element
      class PostcodeQuestion < Question

        rule(:question_type) {
          str("postcode")
        }

        rule(:postcode_question) {
          question_tag.as(:postcode)
        }

        root(:postcode_question)
      end
    end
  end
end

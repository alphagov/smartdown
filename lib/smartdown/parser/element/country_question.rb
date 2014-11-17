require 'smartdown/parser/base'
require 'smartdown/parser/question'

module Smartdown
  module Parser
    module Element
      class CountryQuestion < Question

        rule(:question_type) {
          str("country")
        }

        rule(:country_question) {
          question_tag.as(:country)
        }

        root(:country_question)
      end
    end
  end
end

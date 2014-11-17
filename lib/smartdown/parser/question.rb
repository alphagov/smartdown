require 'smartdown/parser/base'
require 'smartdown/parser/predicates'

module Smartdown
  module Parser
    module Element
      class Question < Base

        rule(:option_pair) {
          comma >>
          optional_space >>
          identifier.as(:key) >>
          colon >>
          optional_space >>
          identifier.as(:value) >>
          optional_space
        }

        rule(:question_tag) {
          (
            str("[") >>
            question_type >>
            str(':') >>
            optional_space >>
            identifier.as(:identifier) >>
            optional_space >>
            option_pair.repeat.as(:option_pairs) >>
            str("]") >>
            optional_space >>
            line_ending
          )
        }

      end
    end
  end
end

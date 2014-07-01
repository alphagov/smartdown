require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class StartButton < Base
        rule(:start_button) {
          str('[start: ') >> question_identifier.as(:start_button) >> str(']') >> line_ending
        }

        root(:start_button)
      end
    end
  end
end

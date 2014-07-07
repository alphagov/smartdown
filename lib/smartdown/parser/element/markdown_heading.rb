require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class MarkdownHeading < Base
        rule(:markdown_heading) {
          str('# ') >> (whitespace_terminated_string).as(:h1) >> optional_space >> line_ending
        }
        root(:markdown_heading)
      end
    end
  end
end

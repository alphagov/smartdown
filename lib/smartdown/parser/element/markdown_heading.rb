require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class MarkdownHeading < Base
        rule(:markdown_heading) {
          str('# ') >> (whitespace_terminated_string >> optional_space >> line_ending).as(:h1)
        }
        root(:markdown_heading)
      end
    end
  end
end

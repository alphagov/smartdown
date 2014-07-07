require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class MarkdownParagraph < Base
        rule(:markdown_line) {
          optional_space >> whitespace_terminated_string >> optional_space
        }

        rule(:markdown_paragraph) {
          (markdown_line >> line_ending).repeat(1).as(:p)
        }

        root(:markdown_paragraph)
      end
    end
  end
end

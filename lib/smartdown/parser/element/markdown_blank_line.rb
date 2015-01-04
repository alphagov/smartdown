require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class MarkdownBlankLine < Base
        rule(:markdown_blank_line) {
          (line_ending).as(:blank)
        }
        root(:markdown_blank_line)
      end
    end
  end
end

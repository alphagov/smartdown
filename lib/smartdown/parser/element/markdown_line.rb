require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class MarkdownLine < Base
        rule(:markdown_line) {
          (optional_space >> whitespace_terminated_string >> optional_space).as(:line)
        }
        root(:markdown_line)
      end
    end
  end
end

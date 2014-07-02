require 'smartdown/parser/base'
require 'smartdown/parser/rules'
require 'smartdown/parser/element/front_matter'
require 'smartdown/parser/element/start_button'
require 'smartdown/parser/element/multiple_choice_question'
require 'smartdown/parser/element/markdown_heading'

module Smartdown
  module Parser
    class NodeParser < Base
      rule(:markdown_line) {
        optional_space >> whitespace_terminated_string >> optional_space
      }

      rule(:markdown_paragraph) {
        (markdown_line >> line_ending).repeat(1).as(:p)
      }

      rule(:markdown_block) {
        Element::MarkdownHeading.new |
          Element::MultipleChoiceQuestion.new |
          Rules.new.as(:next_node_rules) |
          Element::StartButton.new |
          markdown_paragraph
      }

      rule(:markdown_paragraphs) {
        markdown_block >> (newline >> markdown_block).repeat
      }

      rule(:body) {
        markdown_paragraphs.as(:body)
      }

      rule(:flow) {
        Element::FrontMatter.new >> newline.repeat(1) >> body |
          Element::FrontMatter.new |
          ws >> body
      }

      root(:flow)
    end
  end
end

require 'smartdown/parser/base'
require 'smartdown/parser/rules'
require 'smartdown/parser/element/front_matter'
require 'smartdown/parser/element/start_button'
require 'smartdown/parser/element/multiple_choice_question'
require 'smartdown/parser/element/date_question'
require 'smartdown/parser/element/markdown_heading'
require 'smartdown/parser/element/markdown_paragraph'
require 'smartdown/parser/element/conditional'
require 'smartdown/parser/element/next_steps'

module Smartdown
  module Parser
    class NodeParser < Base
      rule(:markdown_block) {
        Element::Conditional.new |
        Element::MarkdownHeading.new |
        Element::MultipleChoiceQuestion.new |
        Element::DateQuestion.new |
        Rules.new |
        Element::StartButton.new |
        Element::NextSteps.new |
        Element::MarkdownParagraph.new
      }

      rule(:markdown_blocks) {
        markdown_block.repeat(1, 1) >> (newline.repeat(1) >> markdown_block).repeat
      }

      rule(:body) {
        markdown_blocks.as(:body)
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

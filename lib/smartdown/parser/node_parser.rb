require 'smartdown/parser/base'
require 'smartdown/parser/rules'
require 'smartdown/parser/element/front_matter'
require 'smartdown/parser/element/start_button'
require 'smartdown/parser/element/multiple_choice_question'
require 'smartdown/parser/element/date_question'
require 'smartdown/parser/element/salary_question'
require 'smartdown/parser/element/text_question'
require 'smartdown/parser/element/country_question'
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
        Element::SalaryQuestion.new |
        Element::TextQuestion.new |
        Element::CountryQuestion.new |
        Rules.new |
        Element::StartButton.new |
        Element::NextSteps.new |
        Element::MarkdownParagraph.new
      }

      # The .repeat(0,1) may look strange because the parselet website says that is the same as .maybe
      #
      #                           !!! .repeat(0,1) is NOT the same as .maybe !!!
      #
      # .repeat calls will not merge as subtrees where as .maybe will. This was the source of many hours
      # of head scratching, so this comment should stay here until the parselet docs (or behavior) are updated.
      rule(:markdown_blocks) {
        markdown_block.repeat(1, 1) >> (newline.repeat(1,1) >> blanklines.as(:blanklines).repeat(0,1) >> (markdown_block)).repeat
      }

      "# Lovely title\n\nline of content\n\n\nanotherlineofcontent"
 #     ("# Lovely title\n": markdown_block, MarkdownHeading) >> (newline >> nil >> ("line of content\n": markdown_block, MarkdownParagraph))


      rule(:body) {
        markdown_blocks.as(:body) >> newline.repeat
      }

      rule(:blanklines) {
        newline.repeat(1)
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

require 'smartdown/parser/base'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/predicates'

module Smartdown
  module Parser
    module Element
      class Conditional < Base
        rule(:markdown_block_inside_conditional) {
          str("$").absent? >> NodeParser.new.markdown_block
        }

        rule(:markdown_blocks_inside_conditional) {
          markdown_block_inside_conditional.repeat(1,1) >> (newline.repeat(1) >> markdown_block_inside_conditional).repeat
        }

        rule(:else_clause) {
          str("$ELSE") >> optional_space >> newline.repeat(2) >>
            (markdown_blocks_inside_conditional.as(:false_case) >> newline).maybe
        }

        rule(:conditional_clause) {
          (
            str("$IF ") >>
              Predicates.new.as(:predicate) >>
              optional_space >> newline.repeat(2) >>
              (markdown_blocks_inside_conditional.as(:true_case) >> newline).maybe >>
              else_clause.maybe >>
              str("$ENDIF") >> optional_space >> line_ending
          ).as(:conditional)
        }

        root(:conditional_clause)
      end
    end
  end
end

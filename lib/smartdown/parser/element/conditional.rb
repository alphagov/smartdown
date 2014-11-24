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

        rule(:conditional_body_block) {
          markdown_block_inside_conditional | conditional_clause
        }

        rule(:blocks_inside_conditional) {
          conditional_body_block.repeat(1,1) >> (newline.repeat(1) >> conditional_body_block).repeat
        }

        rule(:else_clause) {
          str("$ELSE") >> optional_space >> newline.repeat(2) >>
            (blocks_inside_conditional.as(:false_case) >> newline).maybe
        }

        rule(:elseif_clause) {
          str("$ELSEIF ") >> (Predicates.new.as(:predicate) >>
          optional_space >> newline.repeat(2) >>
          (blocks_inside_conditional.as(:true_case) >> newline).maybe >>
          ((elseif_clause | else_clause).maybe)).as(:conditional).repeat(1,1).as(:false_case)
        }

        rule(:conditional_clause) {
          (
            str("$IF ") >>
              Predicates.new.as(:predicate) >>
              optional_space >> newline.repeat(2) >>
              (blocks_inside_conditional.as(:true_case) >> newline).maybe >>
              (else_clause | elseif_clause).maybe >>
              str("$ENDIF") >> optional_space >> line_ending
          ).as(:conditional)
        }

        root(:conditional_clause)
      end
    end
  end
end

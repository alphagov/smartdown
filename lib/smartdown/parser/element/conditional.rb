require 'smartdown/parser/base'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/predicates'

module Smartdown
  module Parser
    module Element
      class Conditional < Base

        rule(:dollar_if)     { str("$IF ") }
        rule(:dollar_else)   { str("$ELSE") }
        rule(:dollar_elseif) { str("$ELSEIF ") }
        rule(:dollar_endif)  { str("$ENDIF") }

        rule(:markdown_block_inside_conditional) {
          dollar_keywords = [dollar_if, dollar_else, dollar_elseif, dollar_endif]
          dollar_keywords.map(&:absent?).reduce(:>>) >> NodeParser.new.markdown_element
        }

        rule(:conditional_body_block) {
          markdown_block_inside_conditional | conditional_clause
        }

        rule(:blocks_inside_conditional) {
          conditional_body_block.repeat(1,1) >> (conditional_body_block).repeat
        }

        rule(:else_clause) {
          dollar_else >>
          optional_space >> newline.repeat(1) >>
          (blocks_inside_conditional.as(:false_case)).maybe
        }

        rule(:elseif_clause) {
          dollar_elseif >> (Predicates.new.as(:predicate) >>
          optional_space >> newline.repeat(1) >>
          (blocks_inside_conditional.as(:true_case)).maybe >>
          ((elseif_clause | else_clause).maybe)).as(:conditional).repeat(1,1).as(:false_case)
        }

        rule(:conditional_clause) {
          (
            dollar_if >>
              Predicates.new.as(:predicate) >>
              optional_space >> newline.repeat(1) >>
              (blocks_inside_conditional.as(:true_case)).maybe >>
              (else_clause | elseif_clause).maybe >>
              dollar_endif >> optional_space >> line_ending
          ).as(:conditional)
        }

        root(:conditional_clause)
      end
    end
  end
end

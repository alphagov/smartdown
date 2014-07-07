require 'smartdown/parser/base'
require 'smartdown/parser/predicates'

module Smartdown
  module Parser
    class Rules < Base
      def indent(depth)
        str(' ').repeat(depth).capture(:indent)
      end

      def conditional_line(depth)
        indent(depth) >> bullet >> optional_space >> Smartdown::Parser::Predicates.new.as(:predicate) >> optional_space >> line_ending
      end

      def children
        dynamic do |s,c|
          current_indent = c.captures[:indent].size
          condition_with_children_or_rule(current_indent + 1).repeat(1)
        end.as(:child_rules)
      end

      def condition_with_children(depth)
        conditional_line(depth) >> children
      end

      def rule(depth)
        (
          indent(depth) >> bullet >> optional_space >>
          Smartdown::Parser::Predicates.new.as(:predicate) >> optional_space >>
          str("=>") >> optional_space >>
          identifier.as(:outcome) >>
          optional_space >> line_ending
        ).as(:rule)
      end

      def condition_with_children_or_rule(depth)
        condition_with_children(depth).as(:nested_rule) | rule(depth)
      end

      rule(:one_top_level_rule) {
        condition_with_children_or_rule(0)
      }

      rule(:rules) {
        one_top_level_rule.repeat(1).as(:next_node_rules)
      }

      root(:rules)
    end
  end
end

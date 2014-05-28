require 'parslet'
require 'smart_answer/node'
require 'smart_answer/question/base'
require 'smart_answer/question/multiple_choice'

module Smartdown
  class NodeParser < Parslet::Parser
    rule(:quoted_string_command) {
      (str("title") | str("hint")).as(:name) >> parameter_list
    }
    rule(:fat_arrow) { str("=>") }
    rule(:option_definitions) {
      whitespace >> identifier.as(:name) >> whitespace >> fat_arrow >> whitespace >> newline_terminated_string.as(:label) >> whitespace
    }
    rule(:bare_parameter_literals) {
      ws_char.repeat >> (identifier.as(:string) >> ws_char.repeat(1) | identifier.as(:string)).repeat >> ws_char.repeat
    }
    rule(:simple_predicate) {
      identifier.as(:name)
    }
    rule(:parameterized_predicate) {
      identifier.as(:name) >> str("(") >> bare_parameter_literals.as(:parameters) >> str(")")
    }

    rule(:predicate_expression) {
      (parameterized_predicate | simple_predicate).as(:predicate)
    }

    rule(:next_node_rule) {
       whitespace >>
         predicate_expression >>
         whitespace >>
         fat_arrow >>
         whitespace >>
         identifier.as(:next_node)
    }

    rule(:predicate_scope) {
      predicate_expression >>
        whitespace >>
        str("{") >>
        next_node_definition.repeat.as(:rules) >>
        str("}")
    }

    rule(:next_node_definition) {
     whitespace >>
       (predicate_scope.as(:nested) | next_node_rule) >>
       whitespace
    }
    rule(:next_node_command) {
      str("next_node").as(:name) >> whitespace >>
        str("{") >>
          next_node_definition.repeat.as(:rules) >>
        str("}")
    }
    rule(:options_command) {
      str("options").as(:name) >> whitespace >> str("{") >> option_definitions.repeat.as(:options) >> str("}")
    }
    rule(:flow_command) {
      next_node_command | options_command | quoted_string_command
    }
    rule(:flow_inner) { flow_command.repeat >> whitespace }
    rule(:flow_body) { str('{') >> whitespace >> flow_inner.as(:commands) >> str('}')}
    rule(:whitespace) { match('[\s\n]').repeat }
    rule(:identifier) { match['a-z_'].repeat(1) >> str("?").maybe }
    rule(:non_newline_non_ws_char) { match('[a-zA-Z,!"]') }
    rule(:ws_char) { match('\s') }
    rule(:newline_terminated_string) { (non_newline_non_ws_char | ws_char >> non_newline_non_ws_char).repeat }
    rule(:quoted_string) { str('"') >> (match('[^"]') | str('\\"')).repeat.as(:quoted_string) >> str('"') }
    rule(:parameter_literal) { quoted_string }
    rule(:parameter_list) {
      str("(") >>
      parameter_literal.maybe >>
      str(")")
    }
    rule(:question_definition) {
      whitespace >>
        identifier.as(:question_type) >>
        str("(") >>
        identifier.as(:question_name) >>
        str(")") >>
        whitespace >>
        flow_body
    }
    rule(:flow) { question_definition >> whitespace }
    root(:flow)
  end
end

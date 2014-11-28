require 'smartdown/parser/base'

module Smartdown
  module Parser
    class Predicates < Base
      rule(:equality_predicate) {
        (
          identifier.as(:varname) >> some_space >>
            str('is') >> some_space >>
            str("'") >> match("[^']").repeat.as(:expected_value) >> str("'")
        ).as(:equality_predicate)
      }

      rule(:comparison_operator) {
        str('>=') | str('>') | str('<=') | str('<')
      }

      rule(:comparison_predicate) {
        (identifier.as(:varname) >> some_space >>
        comparison_operator.as(:operator) >> some_space >>
        str("'") >> match("[^']").repeat.as(:value) >> str("'")).as(:comparison_predicate)
      }

      rule(:set_value) {
        match('[^\s}]').repeat(1).as(:set_value)
      }

      rule(:set_values) {
        (set_value >> some_space).repeat >> set_value
      }

      rule(:set_membership_predicate) {
        (
          identifier.as(:varname) >> some_space >>
            str('in') >> some_space >>
            str("{") >> optional_space >> set_values.maybe.as(:values) >> optional_space >> str("}")
        ).as(:set_membership_predicate)
      }

      rule(:named_predicate) {
        (identifier >> str('?')).as(:named_predicate)
      }

      rule(:otherwise_predicate) {
        str('otherwise').as(:otherwise_predicate)
      }

      rule(:predicate) {
        equality_predicate |
        set_membership_predicate |
        comparison_predicate |
        function_predicate |
        negated_predicate |
        otherwise_predicate |
        named_predicate
      }

      rule (:combined_predicate) {
        predicate.as(:first_predicate) >>
        (some_space >> str('AND') >> some_space >>
        predicate).repeat(1).as(:and_predicates)
      }

      rule (:negated_predicate) {
        (str('NOT') >> some_space >> predicate.as(:predicate)).as(:negated_predicate)
      }

      rule(:function_arguments) {
        identifier.as(:function_argument) >> (some_space >> identifier.as(:function_argument)).repeat
      }

      rule (:function_predicate) {
        ((identifier >> str('?').maybe).as(:name) >>
        str('(') >>
        function_arguments.as(:arguments).maybe >>
        str(')')).as(:function_predicate)
      }

      rule (:predicates) {
        combined_predicate.as(:combined_predicate) |
        predicate
      }

      root(:predicates)
    end
  end
end

require 'smartdown/parser/base'

module Smartdown
  module Parser
    class Predicates < Base
      rule(:equality_predicate) {
        identifier.as(:varname) >> some_space >>
          str('is') >> some_space >>
          str("'") >> match("[^']").repeat.as(:expected_value) >> str("'")
      }

      rule(:comparison_operator) {
        str('>=') | str('>') | str('<=') | str('<')
      }

      rule(:comparison_predicate) {
        identifier.as(:varname) >> some_space >>
        comparison_operator.as(:operator) >> some_space >>
        str("'") >> match("[^']").repeat.as(:value) >> str("'")
      }

      rule(:set_value) {
        match('[^\s}]').repeat(1).as(:set_value)
      }

      rule(:set_values) {
        (set_value >> some_space).repeat >> set_value
      }

      rule(:set_membership_predicate) {
        identifier.as(:varname) >> some_space >>
          str('in') >> some_space >>
          str("{") >> optional_space >> set_values.maybe.as(:values) >> optional_space >> str("}")
      }

      rule(:named_predicate) {
        question_identifier.as(:named_predicate)
      }

      rule(:predicate) {
        equality_predicate.as(:equality_predicate) |
        set_membership_predicate.as(:set_membership_predicate) |
        named_predicate |
        comparison_predicate.as(:comparison_predicate)
      }

      rule (:combined_predicate) {
        predicate.as(:first_predicate) >>
        (some_space >> str('AND') >> some_space >>
        predicate).repeat(1).as(:and_predicates)
      }

      rule (:predicates) {
        combined_predicate.as(:combined_predicate) |
        predicate
      }

      root(:predicates)
    end
  end
end

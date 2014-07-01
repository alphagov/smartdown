require 'smartdown/parser/base'

module Smartdown
  module Parser
    class Predicates < Base
      rule(:equality_predicate) {
        identifier.as(:varname) >> some_space >>
          str('is') >> some_space >>
          str("'") >> match("[^']").repeat.as(:expected_value) >> str("'")
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

      rule(:predicates) {
        equality_predicate.as(:equality_predicate) | set_membership_predicate.as(:set_membership_predicate)
      }

      root(:predicates)
    end
  end
end

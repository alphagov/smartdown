module Smartdown
  class Engine
    class PredicateEvaluator
      def evaluate(predicate, state)
        evaluator_for(predicate).call(state)
      end

    private
      def evaluator_for(predicate)
        case predicate
        when Smartdown::Model::Predicate::Equality
          ->(state) { state.get(predicate.varname) == predicate.expected_value }
        when Smartdown::Model::Predicate::SetMembership
          ->(state) { predicate.values.any? {|value| state.get(predicate.varname) == value } }
        when Smartdown::Model::Predicate::Named
          ->(state) { !!state.get(predicate.name) }
        when Smartdown::Model::Predicate::Comparison::Base
          ->(state) { predicate.evaluate(state.get(predicate.varname)) }
        when Smartdown::Model::Predicate::Combined
          ->(state) { predicate.predicates.map { |p| evaluate(p, state) }.all? }
        else
          raise "Unknown predicate type #{predicate.class}"
        end
      end
    end
  end
end

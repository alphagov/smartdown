module Smartdown
  class Engine
    class PredicateEvaluator
      def evaluate(predicate, state)
        predicate.evaluate(state)
      end
    end
  end
end

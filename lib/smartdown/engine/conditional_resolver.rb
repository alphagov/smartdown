require 'smartdown/engine/predicate_evaluator'

module Smartdown
  class Engine
    class ConditionalResolver
      def initialize(predicate_evaluator = nil)
        @predicate_evaluator = predicate_evaluator || PredicateEvaluator.new
      end

      def call(node, state)
        node.dup.tap do |new_node|
          new_node.elements = resolve_conditionals(node.elements, state)
        end
      end

    private
      attr_accessor :predicate_evaluator

      def evaluate(conditional, state)
        if predicate_evaluator.evaluate(conditional.predicate, state)
          conditional.true_case
        else
          conditional.false_case
        end
      end

      def resolve_conditionals(elements, state)
        elements.map do |element|
          if element.is_a?(Smartdown::Model::Element::Conditional)
            evaluate(element, state)
          else
            element
          end
        end.flatten
      end
    end
  end
end

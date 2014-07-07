require 'smartdown/engine/predicate_evaluator'

module Smartdown
  class Engine
    class Transition
      attr_reader :state, :node, :input

      def initialize(state, node, input, options = {})
        @state = state
        @node = node
        @input = input
        @predicate_evaluator = options[:predicate_evaluator] || PredicateEvaluator.new
      end

      def next_node
        if first_matching_rule
          first_matching_rule.outcome
        else
          raise Smartdown::IndeterminateNextNode
        end
      end

      def next_state
        state_with_input
          .put(:path, state.get(:path) + [node.name])
          .put(:responses, state.get(:responses) + [input])
          .put(node.name, input)
          .put(:current_node, next_node)
      end

    private
      attr_reader :predicate_evaluator

      def next_node_rules
        node.elements.find { |e| e.is_a?(Smartdown::Model::NextNodeRules) } or raise Smartdown::IndeterminateNextNode
      end

      def first_matching_rule
        @first_matching_rule ||= next_node_rules.rules.find do |rule|
          predicate_evaluator.evaluate(rule.predicate, state_with_input)
        end
      end

      def state_with_input
        state.put(node.name, input)
      end
    end
  end
end

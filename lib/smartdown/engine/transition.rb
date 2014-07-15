require 'smartdown/engine/predicate_evaluator'
require 'smartdown/engine/errors'

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
        first_matching_rule(next_node_rules.rules).outcome
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
        node.elements.find { |e| e.is_a?(Smartdown::Model::NextNodeRules) } or \
          raise Smartdown::Engine::IndeterminateNextNode, "No next node rules defined for '#{node.name}'"
      end

      def first_matching_rule(rules)
        catch(:match) do
          throw_first_matching_rule_in(rules)
        end
      end

      def throw_first_matching_rule_in(rules)
        rules.each do |rule|
          case rule
          when Smartdown::Model::Rule
            if predicate_evaluator.evaluate(rule.predicate, state_with_input)
              throw(:match, rule)
            end
          when Smartdown::Model::NestedRule
            if predicate_evaluator.evaluate(rule.predicate, state_with_input)
              throw_first_matching_rule_in(rule.children)
            end
          else
            raise "Unknown rule type"
          end
        end
        raise Smartdown::Engine::IndeterminateNextNode
      end

      def state_with_input
        state.put(node.name, input)
      end
    end
  end
end

require 'smartdown/engine/predicate_evaluator'
require 'smartdown/engine/errors'

module Smartdown
  class Engine
    class Transition
      attr_reader :state, :node, :inputs

      def initialize(state, node, input_array, options = {})
        @state = state
        @node = node
        @inputs = input_array
        @predicate_evaluator = options[:predicate_evaluator] || PredicateEvaluator.new
      end

      def next_node
        next_node_from_next_node_rules ||
        next_node_from_start_button ||
        raise(Smartdown::Engine::IndeterminateNextNode, "No next node rules defined for '#{node.name}'", caller)
      end

      def next_state
        state_with_inputs
          .put(:path, state.get(:path) + [node.name])
          .put(:responses, state.get(:responses) + inputs)
          .put(:current_node, next_node)
      end

    private
      attr_reader :predicate_evaluator

      def next_node_from_next_node_rules
        next_node_rules && first_matching_rule(next_node_rules.rules).outcome
      end

      def next_node_from_start_button
        start_button && start_button.start_node
      end

      def input_variable_names_from_question
        questions = node.elements.select { |e| e.class.to_s.include?("Smartdown::Model::Element::Question") }
        questions.map(&:name)
      end

      def next_node_rules
        node.elements.find { |e| e.is_a?(Smartdown::Model::NextNodeRules) }
      end

      def start_button
        node.elements.find { |e| e.is_a?(Smartdown::Model::Element::StartButton) }
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
            if predicate_evaluator.evaluate(rule.predicate, state_with_inputs)
              throw(:match, rule)
            end
          when Smartdown::Model::NestedRule
            if predicate_evaluator.evaluate(rule.predicate, state_with_inputs)
              throw_first_matching_rule_in(rule.children)
            end
          else
            raise "Unknown rule type"
          end
        end
        raise Smartdown::Engine::IndeterminateNextNode
      end

      def state_with_inputs
        result = state.put(node.name, inputs)
        input_variable_names_from_question.each_with_index do |input_variable_name, index|
          result = result.put(input_variable_name, inputs[index])
        end
        result
      end
    end
  end
end

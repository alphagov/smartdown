require 'smartdown/engine/errors'

module Smartdown
  class Engine
    class Transition
      attr_reader :state, :node, :answers

      def initialize(state, node, answers, options = {})
        @state = state
        @node = node
        @answers = answers
      end

      def next_node
        next_node_from_next_node_rules ||
        next_node_from_start_button ||
        raise(Smartdown::Engine::IndeterminateNextNode, "No next node rules defined for '#{node.name}'", caller)
      end

      def next_state
        state_with_responses
          .put(:path, state.get(:path) + [node.name])
          .put(:accepted_responses, state.get(:accepted_responses) + answers.map(&:to_s))
          .put(:current_node, next_node)
      end

    private
      def next_node_from_next_node_rules
        node.next_node_rules && first_matching_rule(node.next_node_rules.rules).outcome
      end

      def next_node_from_start_button
        node.start_button && node.start_button.start_node
      end

      def input_variable_names_from_question
        node.questions.map(&:name)
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
            if rule.predicate.evaluate(state_with_responses)
              throw(:match, rule)
            end
          when Smartdown::Model::NestedRule
            if rule.predicate.evaluate(state_with_responses)
              throw_first_matching_rule_in(rule.children)
            end
          else
            raise "Unknown rule type"
          end
        end
        raise Smartdown::Engine::IndeterminateNextNode
      end

      def state_with_responses
        result = state.put(node.name, answers.map(&:to_s))
        input_variable_names_from_question.each_with_index do |input_variable_name, index|
          result = result.put(input_variable_name, answers[index])
        end
        result
      end
    end
  end
end

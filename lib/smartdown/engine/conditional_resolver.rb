module Smartdown
  class Engine
    class ConditionalResolver
      def call(node, state)
        node.dup.tap do |new_node|
          new_node.elements = resolve_conditionals(node.elements, state)
        end
      end

    private
      def evaluate(conditional, state)
        if conditional.predicate.evaluate(state)
          selected_branch = conditional.true_case
        else
          selected_branch = conditional.false_case
        end
        resolve_conditionals selected_branch, state
      end

      def resolve_conditionals(elements, state)
        return unless elements
        elements.map do |element|
          if element.is_a? Smartdown::Model::Element::Conditional
            evaluate(element, state)
          else
            element
          end
        end.flatten.compact
      end
    end
  end
end
